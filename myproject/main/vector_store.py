from .models import TourPackage

_model = None
_index = None
_tour_data = []

def get_model_and_index():
    global _model, _index, _tour_data
    if _model is not None:
        return _model, _index, _tour_data

    import os
    os.environ['KMP_DUPLICATE_LIB_OK'] = 'TRUE'

    from sentence_transformers import SentenceTransformer
    import faiss
    import numpy as np

    _model = SentenceTransformer('all-MiniLM-L6-v2')

    tours = TourPackage.objects.filter(is_active=True).prefetch_related('categories')
    
    embeddings = []
    for tour in tours:
        # Get category names as a comma-separated string
        category_names = ", ".join([c.name for c in tour.categories.all()])
        
        text = f"""
        {tour.title}
        Categories: {category_names}
        {tour.short_description}
        {tour.full_description}
        Duration: {tour.duration}
        Price: {tour.price}
        Dates: {tour.upcoming_dates}
        """

        _tour_data.append({
            "title": tour.title,
            "categories": category_names,
            "duration": tour.duration,
            "price": str(tour.price),
            "text": text
        })

        embeddings.append(_model.encode(text))

    if embeddings:
        embeddings_np = np.array(embeddings).astype('float32')
        _index = faiss.IndexFlatL2(embeddings_np.shape[1])
        _index.add(embeddings_np)
    
    return _model, _index, _tour_data

def search_tours(query, k=5):
    model, index, tour_data = get_model_and_index()
    if not index or len(tour_data) == 0:
        return []

    query_embedding = model.encode([query]).astype('float32')

    distances, indices = index.search(query_embedding, k)

    results = []
    for idx in indices[0]:
        if idx >= 0 and idx < len(tour_data):
            results.append(tour_data[idx])

    return results

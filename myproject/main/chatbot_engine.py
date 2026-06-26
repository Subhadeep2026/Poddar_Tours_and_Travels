import google.generativeai as genai
from django.conf import settings
from .vector_store import search_tours

def get_tripnova_answer(question, user_context=""):

    relevant_tours = search_tours(question)

    context = ""

    for tour in relevant_tours:
        context += f"""
Tour: {tour['title']}
Categories: {tour.get('categories', 'None')}
Duration: {tour['duration']}
Price: ₹{tour['price']}
-------------------
"""

    genai.configure(api_key=settings.GEMINI_API_KEY)
    
    system_instruction = f"""
You are TripNova AI, the virtual assistant for Poddar Tours & Travels.

Available Travel Data:
{context}

Current User Information:
{user_context}

Rules:
- If the user asks about their personal bookings, use the 'Current User Information' provided above.
- If the user asks about available tours, use the 'Available Travel Data'.
- Keep responses concise and helpful.
- Use HTML <br> tags for formatting line breaks.
- Do not invent tours or bookings that are not in the context.
"""

    model = genai.GenerativeModel(
        model_name="gemini-2.5-flash",
        system_instruction=system_instruction,
        generation_config=genai.types.GenerationConfig(
            temperature=0.2,
            max_output_tokens=300,
        )
    )

    response = model.generate_content(question)

    return response.text
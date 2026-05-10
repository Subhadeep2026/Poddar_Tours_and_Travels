# Poddar Tours & Travels

Poddar Tours & Travels is a premium, full-featured travel management web application built with Django. It provides a seamless platform for users to explore curated tour packages, book their dream vacations, and manage their travel profiles. The system also includes a robust administrative dashboard for managing tours, bookings, and customer enquiries.

## 🌟 Features

### For Travelers
- **Curated Tour Packages**: Browse tours by categories like Adventure, Honeymoon, Family, and more.
- **Detailed Itineraries**: View day-wise plans, tour highlights, and essential guidelines.
- **Dynamic Booking System**: Easy booking process with real-time price calculation.
- **User Profiles**: Manage personal details, view booking history, and track loyalty points.
- **Reviews & Ratings**: Share travel experiences and read verified reviews from other travelers.
- **Newsletter Subscription**: Stay updated with the latest travel deals and packages.

### For Administrators
- **Comprehensive Dashboard**: Manage tours, itineraries, and gallery images.
- **Booking Management**: Track and update the status of traveler bookings.
- **Enquiry Handling**: View and respond to customer enquiries efficiently.
- **User Management**: Oversee registered users and their profiles.

## 🛠️ Tech Stack

- **Backend**: Django (Python)
- **Database**: MySQL (Production-ready)
- **Frontend**: HTML5, Vanilla CSS, JavaScript (Premium Design)
- **Development Tools**: MySQL Workbench, Django ORM

## 🚀 Getting Started

### Prerequisites
- Python 3.8+
- MySQL Server
- Virtualenv (optional but recommended)

### Installation & Setup

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd poddar_django
   ```

2. **Set up Virtual Environment**
   ```bash
   python -m venv .venv
   # Windows
   .venv\Scripts\activate
   # Linux/Mac
   source .venv/bin/activate
   ```

3. **Install Dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Database Configuration**
   Create a MySQL database named `poddar_tours`. Update your credentials in `myproject/myproject/settings.py`:
   ```python
   DATABASES = {
       'default': {
           'ENGINE': 'django.db.backends.mysql',
           'NAME': 'poddar_tours',
           'USER': 'your_username',
           'PASSWORD': 'your_password',
           'HOST': 'localhost',
           'PORT': '3306',
       }
   }
   ```

5. **Run Migrations**
   ```bash
   cd myproject
   python manage.py migrate
   ```

6. **Seed Database (Optional)**
   Populate the database with initial categories and tour mappings:
   ```bash
   python seed_db.py
   python populate_tours.py
   python populate_rules.py
   ```

7. **Create Superuser**
   ```bash
   python manage.py createsuperuser
   ```

8. **Start the Server**
   ```bash
   python manage.py run_command
   ```
   Visit `http://127.0.0.1:8000` to view the site.

## 📂 Project Structure

- `main/`: Core application containing models, views, and business logic.
- `main/template/`: HTML templates with premium styling.
- `main/static/`: CSS, JS, and image assets.
- `media/`: User-uploaded content (tour images, profile pictures).
- `myproject/`: Project configuration and settings.
- `seed_db.py`: Scripts for initial data population.

## 🎨 UI & Design
The application features a modern, emerald-green branded design with:
- Glassmorphism effects
- Responsive layouts for mobile and desktop
- Interactive hover animations
- High-quality visual assets

## 📄 License
This project is for demonstration/educational purposes.

---
*Built with ❤️ by Poddar Tours & Travels Team*

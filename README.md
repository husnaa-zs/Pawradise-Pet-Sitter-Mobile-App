## Pawradise-Pet-Sitter-Mobile-App

Pawradise is a cat-focused platform built for cat lovers. Whether you're looking to adopt, need a trusted sitter, or want to earn by offering pet care 
Pawradise brings the cat community together.

<img width="1920" height="1080" alt="Purple Pink Gradient Mobile Application Presentation" src="https://github.com/user-attachments/assets/538d7f75-10a1-4bdd-bece-c90cca4af7b5" />


## About our application
Pawradise is a cat community app that allows users to adopt cats, find trusted sitters, or offer pet-sitting services. The app begins with a login or signup page where users can choose their role as either an Owner or a Sitter. Once logged in, users are directed to a personalized homepage that provides access to key features such as cat adoption listings, sitter search, helpful articles on cat care, and profile or booking management. Owners can browse the adoption page to view available cats, apply filters, and submit interest in adopting.

## App flow

```
Welcome (Owner / Sitter)
  → Login or Sign up
    → Home | Sitters | Adopt | Clinic | Profile
```

## Project structure

```
lib/
  main.dart          app entry
  theme.dart         colours and fonts
  data.dart          models and mock data
  state.dart         app state (role, auth, bookings, favourites)
  widgets.dart       shared widgets and pixel cats
  screens/           auth, shell/home, sitters, adoption, clinic, profile
assets/              pixel-art login background and cat sprites
test/                unit tests for the app logic
```
## Features

- **Two roles:** choose Owner or Sitter on the welcome screen. The home screen changes with the role.
- **Login and sign up:** form validation (mock authentication, no real backend yet).
- **Pet sitters:** search, filter (Nearby, Top rated, Available), pick a date and services, see the total price and save the booking.
- **Cat adoption:** search, filter by breed, favourite cats and send adoption requests.
- **Cats clinic:** pick a date, a doctor and a free time slot, then confirm the appointment.
- **Profile:** edit your details and see all your bookings, appointments and adoption requests.
- **Sitter dashboard:** accept or decline booking requests.


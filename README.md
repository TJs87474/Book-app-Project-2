
# 📚 AI-Powered Book Recommendation & Review App

> A smart book companion that recommends, tracks, and discusses books based on your reading preferences.

## 👥 Proposed Group Members

* Ryan Bouapheng
* Tiffany Singleton

## 📖 Project Summary

This app leverages machine learning and user preferences to suggest personalized book recommendations. It includes features such as review writing, reading list management, and community discussions. By integrating with Firebase and third-party APIs like Google Books, the app delivers a seamless user experience centered on discovering and engaging with books.

## 🔗 GitHub Repository

[👉 View the GitHub Repository](https://github.com/your-repo-link-here)

*Replace with actual link*

---

## 🖼️ Wireframe Overview

### 🧱 Layouts

The app is composed of the following unique screens:

1. **Login / Register Screen**
2. **Home / Recommendations**
3. **Book Search**
4. **Book Details & Reviews**
5. **Submit a Review**
6. **Reading List (Tabs: Want to Read, Currently Reading, Finished)**
7. **Discussion Board**
8. **User Profile / Settings**

### 🔄 Functionality (Screen Transitions)

* **Login/Register → Home** : After authentication, user is taken to personalized recommendations.
* **Home → Book Details** : Clicking a book displays detailed metadata, reviews, and actions.
* **Book Details → Review Submission** : Users can write a new review or rate the book.
* **Book Search → Book Details** : From search results to detailed view.
* **Book Details → Add to Reading List** : Choose a list to add the book to.
* **Home / Details / Search → Discussion Board** : Access from any point to engage with the community.

### 💡 User Experience (Use Cases)

* **Login/Register** : Secure authentication and preference syncing via Firebase Auth.
* **Home Screen** : Displays AI-powered book suggestions tailored to user history and preferences.
* **Search** : Query the Google Books API by title, author, or genre.
* **Book Details** : View metadata (title, author, rating, etc.), community reviews, and user actions.
* **Submit Review** : Add personal ratings and written reviews, optionally summarized via OpenAI API.
* **Reading List** : Visualize and update reading status; organized into intuitive tabs.
* **Discussion Board** : Join or start book-related discussions, reply to threads.
* **User Profile** : View and edit genre preferences, settings, and activity history.

### 🔁 Iterative Design Approach

* **User Feedback Collection** : Early beta testers will provide insights via in-app surveys and interviews.
* **Test Cases** :
* Navigation flow testing across screens.
* API call validation (Google Books, Firebase).
* Review posting & syncing reliability.
* **Refinement** :
* A/B testing of recommendation logic.
* UI tweaks based on session analytics and drop-off points.
* Usability enhancements in response to community feedback.

---

## 🔌 Tech Stack & Integration

### ☁️ Firebase

* **Firestore** : Store user profiles, book metadata, reviews, and reading list items.
* **Firebase Auth** : Secure login, account creation, and preference syncing.

### 📚 APIs

* **Google Books API** : Fetch book data such as titles, authors, descriptions, and images.
* **OpenAI API (Optional)** : Enhance reviews with automatic summaries or sentiment analysis.

---

## 🚧 Project Status

> Currently in  **Wireframe & Initial Development Phase** .
>
> Mockups are being validated, and Firebase/Auth setup is underway.

README.md was helped created with OpenAI (5/1/2025).

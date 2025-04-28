// Wait for the DOM to be fully loaded before running scripts
document.addEventListener('DOMContentLoaded', function() {
    setupLanguageSwitch();
    setupImageUpload();
    setupNavigationEvents();
    
    // Initialize the app - default to home screen
    navigateTo('home');
});

// Global variables
let currentLanguage = 'en'; // Default language
let translations = {
    en: {
        appTitle: "Krishi Rakshak",
        home: "Home",
        predict: "Predict",
        forum: "Forum",
        profile: "Profile",
        plantDisease: "Plant Disease",
        animalDisease: "Animal Disease",
        uploadImage: "Upload Image",
        takePicture: "Take Picture",
        detectDisease: "Detect Disease",
        viewHistory: "View History",
        weatherForecast: "Weather Forecast",
        forumPosts: "Forum Posts",
        createPost: "Create Post",
        myPosts: "My Posts",
        login: "Login",
        signup: "Sign Up",
        email: "Email",
        password: "Password",
        name: "Name",
        createAccount: "Create New Account",
        alreadyRegistered: "Already Registered? Log in here",
        language: "Language",
        logout: "Logout",
        cancel: "Cancel",
        submit: "Submit",
        search: "Search",
        temperature: "Temperature",
        humidity: "Humidity",
        wind: "Wind",
        rainfall: "Rainfall",
        symptoms: "Symptoms",
        remedy: "Remedy",
        selectLanguage: "Select Language",
        english: "English",
        hindi: "हिंदी",
        marathi: "मराठी"
    },
    hi: {
        appTitle: "कृषि रक्षक",
        home: "होम",
        predict: "पहचानें",
        forum: "मंच",
        profile: "प्रोफाइल",
        plantDisease: "पौधों के रोग",
        animalDisease: "पशु रोग",
        uploadImage: "छवि अपलोड करें",
        takePicture: "तस्वीर लें",
        detectDisease: "रोग का पता लगाएं",
        viewHistory: "इतिहास देखें",
        weatherForecast: "मौसम का पूर्वानुमान",
        forumPosts: "मंच पोस्ट",
        createPost: "पोस्ट बनाएं",
        myPosts: "मेरी पोस्ट",
        login: "लॉग इन",
        signup: "साइन अप",
        email: "ईमेल",
        password: "पासवर्ड",
        name: "नाम",
        createAccount: "नया खाता बनाएं",
        alreadyRegistered: "पहले से पंजीकृत? यहां लॉग इन करें",
        language: "भाषा",
        logout: "लॉग आउट",
        cancel: "रद्द करें",
        submit: "सबमिट करें",
        search: "खोज",
        temperature: "तापमान",
        humidity: "आर्द्रता",
        wind: "हवा",
        rainfall: "वर्षा",
        symptoms: "लक्षण",
        remedy: "उपचार",
        selectLanguage: "भाषा चुनें",
        english: "English",
        hindi: "हिंदी",
        marathi: "मराठी"
    },
    mr: {
        appTitle: "कृषी रक्षक",
        home: "होम",
        predict: "ओळखा",
        forum: "फोरम",
        profile: "प्रोफाइल",
        plantDisease: "वनस्पती रोग",
        animalDisease: "प्राणी रोग",
        uploadImage: "प्रतिमा अपलोड करा",
        takePicture: "फोटो काढा",
        detectDisease: "रोग शोधा",
        viewHistory: "इतिहास पहा",
        weatherForecast: "हवामान अंदाज",
        forumPosts: "फोरम पोस्ट",
        createPost: "पोस्ट तयार करा",
        myPosts: "माझे पोस्ट",
        login: "लॉगिन",
        signup: "साइन अप",
        email: "ईमेल",
        password: "पासवर्ड",
        name: "नाव",
        createAccount: "नवीन खाते तयार करा",
        alreadyRegistered: "आधीच नोंदणी केली आहे? येथे लॉगिन करा",
        language: "भाषा",
        logout: "लॉगआउट",
        cancel: "रद्द करा",
        submit: "सबमिट करा",
        search: "शोधा",
        temperature: "तापमान",
        humidity: "आर्द्रता",
        wind: "वारा",
        rainfall: "पाऊस",
        symptoms: "लक्षणे",
        remedy: "उपचार",
        selectLanguage: "भाषा निवडा",
        english: "English",
        hindi: "हिंदी",
        marathi: "मराठी"
    }
};

// Function to handle language switching
function setupLanguageSwitch() {
    // Find all language buttons
    const languageButtons = document.querySelectorAll('.language-btn');
    if (languageButtons) {
        languageButtons.forEach(button => {
            button.addEventListener('click', function() {
                const lang = this.getAttribute('data-lang');
                changeLanguage(lang);
                
                // Update active state
                languageButtons.forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');
            });
        });
    }
}

// Function to change language and update UI text
function changeLanguage(lang) {
    if (translations[lang]) {
        currentLanguage = lang;
        
        // Update all elements with 'data-i18n' attribute
        const elements = document.querySelectorAll('[data-i18n]');
        elements.forEach(element => {
            const key = element.getAttribute('data-i18n');
            if (translations[lang][key]) {
                element.textContent = translations[lang][key];
            }
        });
        
        // Update placeholders
        const placeholders = document.querySelectorAll('[data-i18n-placeholder]');
        placeholders.forEach(element => {
            const key = element.getAttribute('data-i18n-placeholder');
            if (translations[lang][key]) {
                element.placeholder = translations[lang][key];
            }
        });
    }
}

// Function to handle image uploads
function setupImageUpload() {
    const uploadBox = document.querySelector('.upload-box');
    const fileInput = document.getElementById('image-upload');
    const previewImage = document.querySelector('.preview-image');
    
    if (uploadBox && fileInput) {
        uploadBox.addEventListener('click', function() {
            fileInput.click();
        });
        
        fileInput.addEventListener('change', function(e) {
            if (e.target.files && e.target.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    if (previewImage) {
                        previewImage.src = e.target.result;
                        previewImage.style.display = 'block';
                    }
                    
                    // Show the detect button
                    const detectButton = document.querySelector('.detect-btn');
                    if (detectButton) {
                        detectButton.style.display = 'block';
                    }
                }
                
                reader.readAsDataURL(e.target.files[0]);
            }
        });
    }
}

// Function to handle navigation between screens
function setupNavigationEvents() {
    // Bottom navigation bar
    const navButtons = document.querySelectorAll('.nav-icon');
    if (navButtons) {
        navButtons.forEach(button => {
            button.addEventListener('click', function() {
                const target = this.getAttribute('data-target');
                navigateTo(target);
            });
        });
    }
    
    // All other navigation buttons
    document.addEventListener('click', function(e) {
        if (e.target.closest('[data-navigate]')) {
            const target = e.target.closest('[data-navigate]').getAttribute('data-navigate');
            navigateTo(target);
        }
    });
}

// Function to navigate to a specific screen
function navigateTo(screenId) {
    // Hide all screens
    const allScreens = document.querySelectorAll('.screen');
    allScreens.forEach(screen => {
        screen.style.display = 'none';
    });
    
    // Show the target screen
    const targetScreen = document.getElementById(screenId + '-screen');
    if (targetScreen) {
        targetScreen.style.display = 'block';
    }
    
    // Update active state in navigation
    const navButtons = document.querySelectorAll('.nav-icon');
    navButtons.forEach(button => {
        if (button.getAttribute('data-target') === screenId) {
            button.classList.add('active');
        } else {
            button.classList.remove('active');
        }
    });
    
    // Execute screen-specific initialization
    if (screenId === 'home') {
        loadWeatherData();
    } else if (screenId === 'forum') {
        loadForumPosts();
    } else if (screenId === 'disease-info') {
        // If we have a selected disease, load its details
        const diseaseId = localStorage.getItem('selectedDiseaseId');
        if (diseaseId) {
            loadDiseaseDetails(diseaseId);
        }
    }
}

// Function to load weather data
function loadWeatherData() {
    // This would typically fetch from a weather API
    // For now, we'll use dummy data
    const weatherWidget = document.querySelector('.weather-widget');
    if (weatherWidget) {
        // Update weather based on geolocation in a real app
        weatherWidget.querySelector('.weather-location').textContent = 'Pune, Maharashtra';
        weatherWidget.querySelector('.weather-temp').textContent = '32°C';
        weatherWidget.querySelector('.weather-desc').textContent = 'Partly Cloudy';
    }
}

// Function to load forum posts
function loadForumPosts() {
    const forumContainer = document.querySelector('.forum-posts-container');
    if (!forumContainer) return;
    
    // Show loading state
    forumContainer.innerHTML = '<div class="loading"><div class="spinner"></div></div>';
    
    // Fetch forum posts from API
    fetch('/forum/posts')
        .then(response => response.json())
        .then(data => {
            if (data.success && data.posts) {
                // Clear loading state
                forumContainer.innerHTML = '';
                
                // Display posts
                data.posts.forEach(post => {
                    const postElement = createForumPostElement(post);
                    forumContainer.appendChild(postElement);
                });
                
                if (data.posts.length === 0) {
                    forumContainer.innerHTML = '<p>No forum posts yet. Be the first to create one!</p>';
                }
            } else {
                forumContainer.innerHTML = '<p>Failed to load forum posts. Please try again later.</p>';
            }
        })
        .catch(error => {
            console.error('Error loading forum posts:', error);
            forumContainer.innerHTML = '<p>Failed to load forum posts. Please try again later.</p>';
        });
}

// Function to create a forum post element
function createForumPostElement(post) {
    const postElement = document.createElement('div');
    postElement.className = 'forum-post';
    
    const formattedDate = new Date(post.created_at).toLocaleDateString();
    
    postElement.innerHTML = `
        <div class="post-header">
            <div>
                <div class="post-title">${post.title}</div>
                <div class="post-author">${post.author_name}</div>
            </div>
            <div class="post-date">${formattedDate}</div>
        </div>
        <div class="post-content">${post.content}</div>
        <div class="post-comments">
            <h4>Comments (${post.comments.length})</h4>
            ${post.comments.map(comment => `
                <div class="comment">
                    <div class="comment-author">${comment.author_name}</div>
                    <div class="comment-content">${comment.content}</div>
                </div>
            `).join('')}
        </div>
    `;
    
    return postElement;
}

// Function to load disease details
function loadDiseaseDetails(diseaseId) {
    const diseaseContainer = document.querySelector('.disease-details-container');
    if (!diseaseContainer) return;
    
    // Show loading state
    diseaseContainer.innerHTML = '<div class="loading"><div class="spinner"></div></div>';
    
    // Fetch disease details from API
    fetch(`/diseases/${diseaseId}`)
        .then(response => response.json())
        .then(data => {
            if (data.success && data.disease) {
                const disease = data.disease;
                
                // Create disease detail view
                diseaseContainer.innerHTML = `
                    <div class="disease-card">
                        <img src="/static/images/diseases/${disease.type}_default.jpg" alt="${disease.name}" class="disease-image">
                        <div class="disease-title">${disease.name}</div>
                        <div class="disease-description">
                            <h3 data-i18n="symptoms">Symptoms</h3>
                            <p>${disease.symptoms}</p>
                            
                            <h3 data-i18n="remedy">Remedy</h3>
                            <p>${disease.remedy}</p>
                        </div>
                    </div>
                `;
                
                // Update text with current language
                changeLanguage(currentLanguage);
            } else {
                diseaseContainer.innerHTML = '<p>Failed to load disease details. Please try again later.</p>';
            }
        })
        .catch(error => {
            console.error('Error loading disease details:', error);
            diseaseContainer.innerHTML = '<p>Failed to load disease details. Please try again later.</p>';
        });
}

// Function to handle disease prediction
function predictDisease(type) {
    const fileInput = document.getElementById('image-upload');
    const resultContainer = document.querySelector('.prediction-result');
    
    if (!fileInput.files || fileInput.files.length === 0) {
        alert('Please upload an image first.');
        return;
    }
    
    // Show loading state
    resultContainer.innerHTML = '<div class="loading"><div class="spinner"></div></div>';
    
    const file = fileInput.files[0];
    const reader = new FileReader();
    
    reader.onload = function(e) {
        // Get the base64 data (remove the data URL prefix)
        const base64Image = e.target.result.split(',')[1];
        
        // Prepare the request data
        const requestData = {
            image: base64Image
        };
        
        // Send the request to the appropriate API endpoint
        fetch(`/predict/${type}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(requestData)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success && data.prediction) {
                const prediction = data.prediction;
                
                // Store the disease ID for viewing details
                if (prediction.disease_id) {
                    localStorage.setItem('selectedDiseaseId', prediction.disease_id);
                }
                
                // Display the prediction result
                resultContainer.innerHTML = `
                    <div class="disease-card">
                        <div class="disease-title">${prediction.disease_name}</div>
                        <div class="rating">
                            <div class="confidence">Confidence: ${(prediction.confidence_score * 100).toFixed(1)}%</div>
                            <div class="stars">
                                ${getStarsHTML(prediction.confidence_score * 5)}
                            </div>
                        </div>
                        <div class="disease-description">
                            <h3 data-i18n="symptoms">Symptoms</h3>
                            <p>${prediction.symptoms}</p>
                            
                            <h3 data-i18n="remedy">Remedy</h3>
                            <p>${prediction.remedy}</p>
                        </div>
                        <button class="btn btn-primary btn-block" onclick="navigateTo('disease-info')">View Details</button>
                    </div>
                `;
                
                // Update text with current language
                changeLanguage(currentLanguage);
            } else {
                resultContainer.innerHTML = '<p>Failed to make prediction. Please try again with a clearer image.</p>';
            }
        })
        .catch(error => {
            console.error('Error making prediction:', error);
            resultContainer.innerHTML = '<p>Failed to make prediction. Please check your connection and try again.</p>';
        });
    };
    
    reader.readAsDataURL(file);
}

// Function to generate HTML for star ratings
function getStarsHTML(rating) {
    const fullStars = Math.floor(rating);
    const halfStar = rating % 1 >= 0.5;
    const emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
    
    let starsHTML = '';
    
    // Add full stars
    for (let i = 0; i < fullStars; i++) {
        starsHTML += '<span class="star">★</span>';
    }
    
    // Add half star if needed
    if (halfStar) {
        starsHTML += '<span class="star">⯪</span>';
    }
    
    // Add empty stars
    for (let i = 0; i < emptyStars; i++) {
        starsHTML += '<span class="star">☆</span>';
    }
    
    return starsHTML;
}

// Function to handle forum post creation
function createForumPost() {
    const titleInput = document.getElementById('post-title');
    const contentInput = document.getElementById('post-content');
    const authorInput = document.getElementById('post-author');
    
    if (!titleInput.value.trim() || !contentInput.value.trim() || !authorInput.value.trim()) {
        alert('Please fill in all fields.');
        return;
    }
    
    const requestData = {
        title: titleInput.value.trim(),
        content: contentInput.value.trim(),
        author_name: authorInput.value.trim()
    };
    
    // Send the request to create a forum post
    fetch('/forum/posts', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(requestData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Clear the form
            titleInput.value = '';
            contentInput.value = '';
            
            // Navigate back to forum posts
            navigateTo('forum');
            
            // Reload forum posts
            loadForumPosts();
        } else {
            alert('Failed to create post: ' + (data.error || 'Unknown error'));
        }
    })
    .catch(error => {
        console.error('Error creating forum post:', error);
        alert('Failed to create post. Please check your connection and try again.');
    });
}
import os
from flask import Flask, jsonify, request
from werkzeug.utils import secure_filename
import tensorflow as tf
from PIL import Image
import numpy as np
from pydantic import BaseModel, Field, EmailStr
from bson import ObjectId
from motor.motor_asyncio import AsyncIOMotorClient
from pymongo import MongoClient
from flask_pydantic import validate
from werkzeug.security import check_password_hash
from typing import Optional
import traceback

# Initialize Flask app
app = Flask(__name__)

# Upload directory
UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# MongoDB client setup
MONGODB_CONNECTION_URL = "mongodb+srv://hiruniwijerathna7:iFS2gQDD3lRHtVp3@cluster0.4lyx8.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
client = MongoClient(MONGODB_CONNECTION_URL)
db = client["user-prefs"]
user_collection = db["users"]

# models
bean_model = tf.keras.models.load_model('beans/beans.h5')
potato_model = tf.keras.models.load_model('potato/potato.h5')
tomato_model = tf.keras.models.load_model('tomato/tomato.h5')

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

# Labels
beans_label_map = {
    0: 'angular_leaf_spot',
    1: 'bean_rust',
    2: 'healthy'
}

potato_label_map = {
    0:'early_blight', 
    1:'late_blight', 
    2:'healthy'
}

tomato_label_map = {
    1: 'Tomato___Bacterial_spot',
    2: 'Tomato___Early_blight',
    3: 'Tomato___Late_blight',
    4: 'Tomato___Leaf_Mold',
    5: 'Tomato___Septoria_leaf_spot',
    6: 'Tomato___Spider_mites Two-spotted_spider_mite',
    7: 'Tomato___Target_Spot',
    8: 'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
    9: 'Tomato___Tomato_mosaic_virus',
    10: 'Tomato___healthy'
}



@app.route('/api/beans-predict', methods=['POST'])
def beans_predict():
    # Handle File Upload
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400
    
    file = request.files['file']

    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400

    if file:
        filename = secure_filename(file.filename)
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(file_path)

        try:
            img = Image.open(file_path).resize((224, 224))  
            img_array = np.array(img) / 255.0  
            img_array = np.expand_dims(img_array, axis=0)  

            # Making prediction
            prediction = bean_model.predict(img_array)
            predicted_class = np.argmax(prediction, axis=1)[0]

            # Handle label notFound
            predicted_label = beans_label_map.get(predicted_class, 'Unknown')

            return jsonify({
                'prediction': int(predicted_class),
                'predicted_label': predicted_label,
                'message': 'Prediction successful'
            })
        except Exception as e:
            return jsonify({'error': str(e)}), 500
        

@app.route('/api/potato-predict', methods=['POST'])
def potato_predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400

    if file:
        filename = secure_filename(file.filename)
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(file_path)

        try:
            img = Image.open(file_path).resize((224, 224))  
            img_array = np.array(img) / 255.0  
            img_array = np.expand_dims(img_array, axis=0)  

            prediction = potato_model.predict(img_array)
            predicted_class = np.argmax(prediction, axis=1)[0]

            predicted_label = potato_label_map.get(predicted_class, 'Unknown')

            return jsonify({
                'prediction': int(predicted_class),
                'predicted_label': predicted_label,
                'message': 'Prediction successful'
            })
        except Exception as e:
            return jsonify({'error': str(e)}), 500

@app.route('/api/tomato-predict', methods=['POST'])
def tomato_predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    if file:
        filename = secure_filename(file.filename)
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(file_path)

        try:
            img = Image.open(file_path).resize((224, 224))  
            img_array = np.array(img) / 255.0  
            img_array = np.expand_dims(img_array, axis=0)  

            prediction = tomato_model.predict(img_array)
            predicted_class = np.argmax(prediction, axis=1)[0]
            predicted_label = tomato_label_map.get(predicted_class, 'Unknown')

            return jsonify({
                'prediction': int(predicted_class),
                'predicted_label': predicted_label,
                'message': 'Prediction successful'
            })
        except Exception as e:
            return jsonify({'error': str(e)}), 500


class User(BaseModel):
    fullname: str = Field(..., min_length=2, max_length=50)
    lastname: str = Field(..., min_length=2, max_length=50)
    mobile: str = Field(..., pattern=r'^0\d{9}$')  
    email: EmailStr
    username: str = Field(..., min_length=3, max_length=20)
    password: str = Field(..., min_length=6)
    accepted: bool = False  
    avatar: Optional[str] = Field(default="https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png")

# Route to create a new user
@app.route('/api/create-user', methods=['POST'])
@validate(body=User)
def create_user():
    try:
        # Get the validated user data from request body
        user_data = request.get_json()
        # Insert the user into MongoDB
        result = user_collection.insert_one(user_data)
        return jsonify({"msg": "User created successfully!", "user_id": str(result.inserted_id)})
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/api/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        username = data['username']
        password = data['password']
        
        # Find the user in the database
        db_user = user_collection.find_one({"username": username})
        if db_user is None:
            return jsonify({"error": "User not found"}), 404
        
        # Check password
        if db_user['password'] != password:
            return jsonify({"error": "Invalid credentials"}), 400
        
        # Remove the password from the user details before returning
        user_data = {
            "fullname": db_user['fullname'],
            "lastname": db_user['lastname'],
            "mobile": db_user['mobile'],
            "email": db_user['email'],
            "avatar": db_user.get('avatar', 'https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png'),
            "username": db_user['username'],
            "accepted": db_user.get('accepted', False),  # Include accepted field if present
            "user_id": str(db_user["_id"])
        }
        
        return jsonify({"msg": "Login successful!", "user": user_data})
    
    except Exception as e:
        return jsonify({"error": str(e)}), 400
class UserUpdate(BaseModel):
    username: str
    fullname: Optional[str] = None
    lastname: Optional[str] = None
    mobile: Optional[str] = None
    email: Optional[EmailStr] = None
    avatar: Optional[str] = None
    accepted: Optional[bool] = None

@app.route('/api/update-profile', methods=['PATCH'])
@validate(body=UserUpdate)
def update_profile():
    try:
        # Extract the JSON body
        user_data = request.get_json()
        
        # Ensure 'username' is in the request body
        username = user_data.get('username')
        if not username:
            return jsonify({"error": "Username is required"}), 400
        
        # Find the user in the database
        db_user = user_collection.find_one({"username": username})
        if db_user is None:
            return jsonify({"error": "User not found"}), 404
        
        # Prepare the update data
        update_data = {
            "fullname": user_data.get('fullname', db_user['fullname']),
            "lastname": user_data.get('lastname', db_user.get('lastname', '')),
            "mobile": user_data.get('mobile', db_user['mobile']),
            "email": user_data.get('email', db_user['email']),
            "avatar": user_data.get('avatar', db_user.get('avatar', 'https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png')),
            "accepted": user_data.get('accepted', db_user.get('accepted'))
        }
        
        # Update the user in the database
        user_collection.update_one({"username": username}, {"$set": update_data})
        
        return jsonify({"msg": "Profile updated successfully!"})
    
    except Exception as e:
        # Capture and return the error trace
        error_trace = traceback.format_exc()
        print(f"Error: {error_trace}")
        return jsonify({"error": str(e), "traceback": error_trace}), 400

@app.route('/api/user/<username>', methods=['GET'])
def get_user(username):
    try:
        # Find the user in the database by username
        db_user = user_collection.find_one({"username": username})
        
        if db_user is None:
            return jsonify({"error": "User not found"}), 404
        
        # Exclude the password from the returned data
        user_data = {
            "fullname": db_user['fullname'],
            "lastname": db_user['lastname'],
            "mobile": db_user['mobile'],
            "email": db_user['email'],
            "username": db_user['username'],
            "accepted": db_user.get('accepted', False),  # Include accepted field if present
            "avatar": db_user.get('avatar', "https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png")
        }
        
        return jsonify({"user": user_data})
    
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/api/update-password', methods=['PATCH'])
def update_password():
    try:
        # Extract JSON body
        data = request.get_json()
        mobile = data.get('mobile')
        new_password = data.get('new_password')
        confirm_password = data.get('confirm_password')

        # Validate input
        if not mobile or not new_password or not confirm_password:
            return jsonify({"error": "All fields are required"}), 400

        if new_password != confirm_password:
            return jsonify({"error": "Passwords do not match"}), 400

        # Find the user in the database
        db_user = user_collection.find_one({"mobile": mobile})
        if db_user is None:
            return jsonify({"error": "User not found"}), 404

        # Hash the new password
        # hashed_password = bcrypt.hashpw(new_password.encode('utf-8'), bcrypt.gensalt())

        # Update the user's password
        user_collection.update_one({"mobile": mobile}, {"$set": {"password": new_password}})
        
        return jsonify({"msg": "Password updated successfully!"})
    
    except Exception as e:
        # Capture and return the error trace
        error_trace = traceback.format_exc()
        print(f"Error: {error_trace}")
        return jsonify({"error": str(e), "traceback": error_trace}), 400

# Run Flask app
if __name__ == '__main__':
    app.run(debug=True)

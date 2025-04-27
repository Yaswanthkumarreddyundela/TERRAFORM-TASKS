# app.py
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import os

# Initialize Flask app
app = Flask(__name__)

# Configure SQLite database
BASE_DIR = os.path.abspath(os.path.dirname(__file__))
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(BASE_DIR, 'incidents.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize SQLAlchemy
db = SQLAlchemy(app)

# Define Incident model
class Incident(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    severity = db.Column(db.String(10), nullable=False)
    reported_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'description': self.description,
            'severity': self.severity,
            'reported_at': self.reported_at.isoformat() + 'Z'
        }

# Validate severity level
def validate_severity(severity):
    valid_severities = ['Low', 'Medium', 'High']
    return severity in valid_severities

# API endpoints
@app.route('/incidents', methods=['GET'])
def get_incidents():
    incidents = Incident.query.all()
    return jsonify([incident.to_dict() for incident in incidents]), 200

@app.route('/incidents', methods=['POST'])
def create_incident():
    data = request.get_json()
    
    # Validate required fields
    if not all(key in data for key in ['title', 'description', 'severity']):
        return jsonify({'error': 'Missing required fields'}), 400
    
    # Validate severity
    if not validate_severity(data['severity']):
        return jsonify({'error': 'Invalid severity level. Must be Low, Medium, or High'}), 400
    
    # Create new incident
    new_incident = Incident(
        title=data['title'],
        description=data['description'],
        severity=data['severity']
    )
    
    db.session.add(new_incident)
    db.session.commit()
    
    return jsonify(new_incident.to_dict()), 201

@app.route('/incidents/<int:id>', methods=['GET'])
def get_incident(id):
    incident = Incident.query.get(id)
    
    if not incident:
        return jsonify({'error': 'Incident not found'}), 404
    
    return jsonify(incident.to_dict()), 200

@app.route('/incidents/<int:id>', methods=['DELETE'])
def delete_incident(id):
    incident = Incident.query.get(id)
    
    if not incident:
        return jsonify({'error': 'Incident not found'}), 404
    
    db.session.delete(incident)
    db.session.commit()
    
    return '', 204

# Initialize the database
def init_db():
    with app.app_context():
        db.create_all()
        
        # Check if we already have sample data
        if Incident.query.count() == 0:
            # Add sample incidents
            sample_incidents = [
                Incident(
                    title="Model Output Hallucination",
                    description="AI model generated factually incorrect historical information that appeared plausible but was completely fabricated.",
                    severity="Medium"
                ),
                Incident(
                    title="Biased Decision Recommendation",
                    description="System consistently recommended against qualified candidates from underrepresented groups in hiring tool.",
                    severity="High"
                ),
                Incident(
                    title="Minor Privacy Leak",
                    description="System occasionally included private user information in its responses when not relevant to query.",
                    severity="Low"
                )
            ]
            
            db.session.bulk_save_objects(sample_incidents)
            db.session.commit()
            print("Database initialized with sample data.")

if __name__ == '__main__':
    init_db()
    app.run(debug=True)
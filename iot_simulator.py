import time
import random
import json
import requests # You might need to install requests: pip install requests

# Configuration
# For local testing with Android Emulator, use 10.0.2.2 instead of localhost if running heavily on emulator
# But since this is a script, standard localhost is fine if backend is local.
# If backend is Firebase, we might write directly to Firestore (requires admin sdk) 
# OR just print the data for the hackathon demo to show "Console Output".

print("--- Smart Pole IoT Simulator Started ---")
print("Simulating 5 Smart Poles in MSIT Area...")

poles = [
    {"id": "POLE_001", "lat": 28.6219, "lng": 77.0878, "status": "ACTIVE"},
    {"id": "POLE_002", "lat": 28.6225, "lng": 77.0882, "status": "ACTIVE"},
    {"id": "POLE_003", "lat": 28.6210, "lng": 77.0870, "status": "ACTIVE"},
    {"id": "POLE_004", "lat": 28.6230, "lng": 77.0890, "status": "ACTIVE"},
    {"id": "POLE_005", "lat": 28.6205, "lng": 77.0865, "status": "ACTIVE"},
]

def generate_telemetry(pole):
    # Simulate sensor data
    is_motion = random.random() > 0.7
    audio_level = random.uniform(30.0, 90.0) # dB
    
    # "Scream Detection" logic
    is_anomaly = audio_level > 85.0
    
    data = {
        "device_id": pole["id"],
        "timestamp": time.time(),
        "location": {"lat": pole["lat"], "lng": pole["lng"]},
        "sensors": {
            "motion": is_motion,
            "audio_level_db": round(audio_level, 2)
        },
        "alert": is_anomaly
    }
    return data

try:
    while True:
        for pole in poles:
            telemetry = generate_telemetry(pole)
            
            if telemetry["alert"]:
                 print(f"[ALERT] {telemetry['device_id']} detected HIGH NOISE ({telemetry['sensors']['audio_level_db']}dB) at {telemetry['location']}")
                 # In a real app, POST this to your Cloud Function / Backend
                 # requests.post("https://your-api.com/iot-alert", json=telemetry)
            else:
                # Setup "Heartbeat" (optional print to not spam console)
                if random.random() > 0.9:
                    print(f"[HEARTBEAT] {telemetry['device_id']} is monitoring...")
                    
        time.sleep(2) # Wait 2 seconds before next poll

except KeyboardInterrupt:
    print("\nSimulation stopped.")

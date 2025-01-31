from flask import Flask, jsonify
import requests

app = Flask(__name__)

# Have I Been Pwned API URL
HIBP_API_URL = "https://haveibeenpwned.com/api/v3/breaches"

@app.route('/breaches', methods=['GET'])
def get_breaches():
    """
    Fetches all breaches from the Have I Been Pwned API and sorts them by ModifiedDate.
    """
    try:
        # Query the Have I Been Pwned API
        response = requests.get(HIBP_API_URL, headers={"User-Agent": "Breach-Tracker-App"})
        response.raise_for_status()
        data = response.json()

        # Sort breaches by ModifiedDate in descending order
        sorted_breaches = sorted(data, key=lambda x: x.get("ModifiedDate", ""), reverse=True)

        return jsonify({"message": "Breaches fetched successfully.", "breaches": sorted_breaches}), 200

    except Exception as e:
        return jsonify({"message": "An error occurred.", "error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)


from flask import Flask, jsonify, request
from flask_mysqldb import MySQL
from flask_cors import CORS  # Import CORS

app = Flask(__name__)

CORS(app, resources={r"/*": {"origins": "http://localhost:3000"}})

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '7%g#hu89@$'
app.config['MYSQL_DB'] = 'P3'

mysql = MySQL(app)

@app.route('/player/<int:player_id>', methods=['GET'])
def get_player_info(player_id):
    cursor = mysql.connection.cursor()

    query = "SELECT * FROM Player WHERE Player_ID = %s"
    cursor.execute(query, (player_id,))
    result = cursor.fetchone()
    cursor.close()

    player_info = {
        "Player_ID": result[0],
        "Player_Name": result[1],
        "Player_Email": result[2],
        "Player_Password": result[3],
        "Mode1_highest": result[4],
        "Mode2_highest": result[5],
        "Mode1_trial_count": result[6],
        "Title_ID_activated": result[7],
        "Pet_ID_activated": result[8]
    }

    return jsonify(player_info), 200

@app.route('/player/<int:player_id>', methods=['DELETE'])
def delete_player(player_id):
    cursor = mysql.connection.cursor()

    query = "DELETE FROM Player WHERE Player_ID = %s"
    cursor.execute(query, (player_id,))
    mysql.connection.commit()
    cursor.close()

    return jsonify({"message": "Player successfully deleted", "Player_ID": player_id}), 200

@app.route('/player', methods=['POST'])
def add_player():
    data = request.json

    player_name = data['Player_Name']
    player_email = data['Player_Email']
    player_password = data['Player_Password']
    mode1_highest = data.get('Mode1_highest', 0)
    mode2_highest = data.get('Mode2_highest', 0)
    mode1_trial_count = data.get('Mode1_trial_count', 0)
    title_id_activated = data.get('Title_ID_activated', None)
    pet_id_activated = data.get('Pet_ID_activated', None)

    cursor = mysql.connection.cursor()

    query = """
        INSERT INTO Player (Player_Name, Player_Email, Player_Password, Mode1_highest, Mode2_highest, Mode1_trial_count, Title_ID_activated, Pet_ID_activated)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """
    cursor.execute(query, (player_name, player_email, player_password, mode1_highest, mode2_highest, mode1_trial_count, title_id_activated, pet_id_activated))
    mysql.connection.commit()
    new_player_id = cursor.lastrowid
    cursor.close()

    return jsonify({
        "message": "Player added successfully",
        "Player_ID": new_player_id,
        "Player_Name": player_name,
        "Player_Email": player_email
    }), 200

@app.route('/player/<int:player_id>/update-pet', methods=['PUT'])
def update_pet_activated(player_id):
    data = request.json
    new_pet_id = data['Pet_ID_activated']
    cursor = mysql.connection.cursor()

    query = "UPDATE Player SET Pet_ID_activated = %s WHERE Player_ID = %s"
    cursor.execute(query, (new_pet_id, player_id))
    mysql.connection.commit()
    affected_rows = cursor.rowcount
    cursor.close()

    return jsonify({
        "message": "Pet_ID_activated updated successfully",
        "Player_ID": player_id,
        "Pet_ID_activated": new_pet_id
    }), 200


@app.route('/player/<int:player_id>/friends', methods=['GET'])
def get_friends(player_id):
    cursor = mysql.connection.cursor()

    query = """
            SELECT P.Player_ID, P.Player_Name, F.Intimacy
            FROM Friend F
            INNER JOIN Player P ON F.Player2_ID = P.Player_ID
            WHERE F.Player1_ID = %s
        """
    cursor.execute(query, (player_id,))
    result = cursor.fetchall()
    cursor.close()

    friends = [
        {"Player_ID": row[0], "Player_Name": row[1], "Intimacy": row[2]}
        for row in result
    ]

    return jsonify({"Player1_ID": player_id, "Friends": friends}), 200

@app.route('/player/<int:player1_id>/friend/<int:player2_id>', methods=['DELETE'])
def delete_friend(player1_id, player2_id):
    cursor = mysql.connection.cursor()

    query = "DELETE FROM Friend WHERE Player1_ID = %s AND Player2_ID = %s"
    cursor.execute(query, (player1_id, player2_id))
    mysql.connection.commit()
    cursor.close()

    return jsonify({"message": "Friendship successfully deleted", "Player1_ID": player1_id, "Player2_ID": player2_id}), 200

@app.route('/player/<int:player1_id>/friend/<int:player2_id>/update-intimacy', methods=['PUT'])
def update_friend_intimacy(player1_id, player2_id):
    data = request.json
    new_intimacy = data['Intimacy']
    cursor = mysql.connection.cursor()

    query = "UPDATE Friend SET Intimacy = %s WHERE Player1_ID = %s AND Player2_ID = %s"
    cursor.execute(query, (new_intimacy, player1_id, player2_id))
    mysql.connection.commit()
    cursor.close()

    return jsonify({
        "message": "Intimacy updated successfully",
        "Player1_ID": player1_id,
        "Player2_ID": player2_id,
        "Intimacy": new_intimacy
    }), 200

@app.route('/player/<int:player1_id>/friend', methods=['POST'])
def add_friend(player1_id):
    data = request.json
    player2_id = data['Player2_ID']
    intimacy = data['Intimacy']
    cursor = mysql.connection.cursor()

    query = """
        INSERT INTO Friend (Player1_ID, Player2_ID, Intimacy)
        VALUES (%s, %s, %s)
    """
    cursor.execute(query, (player1_id, player2_id, intimacy))
    mysql.connection.commit()
    cursor.close()

    return jsonify({
        "message": "Friendship added successfully",
        "Player1_ID": player1_id,
        "Player2_ID": player2_id,
        "Intimacy": intimacy
    }), 200



@app.route('/pet/<int:pet_id>', methods=['GET'])
def get_pet_by_id(pet_id):
    cursor = mysql.connection.cursor()

    query = "SELECT * FROM Pet WHERE Pet_ID = %s"
    cursor.execute(query, (pet_id,))
    result = cursor.fetchone()
    cursor.close()

    pet = {
        "Pet_ID": result[0],
        "Pet_image": result[1],
        "Rarity": result[2],
        "GenderType": result[3]
    }

    return jsonify(pet), 200

@app.route('/pets', methods=['POST'])
def add_pet():
    data = request.json
    pet_image = data['Pet_image']
    rarity = data['Rarity']
    gender_type = data['GenderType']
    cursor = mysql.connection.cursor()

    query = """
        INSERT INTO Pet (Pet_image, Rarity, GenderType)
        VALUES (%s, %s, %s)
    """
    cursor.execute(query, (pet_image, rarity, gender_type))
    mysql.connection.commit()
    new_pet_id = cursor.lastrowid
    cursor.close()

    return jsonify({
        "message": "Pet added successfully",
        "Pet_ID": new_pet_id,
        "Pet_image": pet_image,
        "Rarity": rarity,
        "GenderType": gender_type
    }), 200

@app.route('/pet/<int:pet_id>', methods=['DELETE'])
def delete_pet(pet_id):
    cursor = mysql.connection.cursor()

    query = "DELETE FROM Pet WHERE Pet_ID = %s"
    cursor.execute(query, (pet_id,))
    mysql.connection.commit()
    cursor.close()

    return jsonify({"message": "Pet successfully deleted", "Pet_ID": pet_id}), 200

@app.route('/pet/<int:pet_id>/update-rarity', methods=['PUT'])
def update_pet_rarity(pet_id):
    data = request.json

    new_rarity = data['Rarity']

    cursor = mysql.connection.cursor()

    query = "UPDATE Pet SET Rarity = %s WHERE Pet_ID = %s"
    cursor.execute(query, (new_rarity, pet_id))
    mysql.connection.commit()
    cursor.close()

    return jsonify({
        "message": "Rarity updated successfully",
        "Pet_ID": pet_id,
        "New_Rarity": new_rarity
    }), 200


@app.route('/player/<int:player_id>/pets', methods=['GET'])
def get_pets_by_player(player_id):
    cursor = mysql.connection.cursor()

    query = """
        SELECT PP.Pet_ID, PP.Pet_name
        FROM Player_pet PP
        WHERE PP.Player_ID = %s
    """
    cursor.execute(query, (player_id,))
    result = cursor.fetchall()
    cursor.close()

    pets = [
        {
            "Pet_ID": row[0],
            "Pet_name": row[1]
        }
        for row in result
    ]

    return jsonify({"Player_ID": player_id, "Pets": pets}), 200

@app.route('/player/<int:player_id>/add-pet', methods=['POST'])
def add_pet_to_player(player_id):
    data = request.json

    pet_id = data['Pet_ID']
    pet_name = data['Pet_name']

    cursor = mysql.connection.cursor()

    query = """
        INSERT INTO Player_pet (Player_ID, Pet_ID, Pet_name)
        VALUES (%s, %s, %s)
    """
    cursor.execute(query, (player_id, pet_id, pet_name))
    mysql.connection.commit()
    cursor.close()

    return jsonify({
        "message": "Pet added successfully",
        "Player_ID": player_id,
        "Pet_ID": pet_id,
        "Pet_name": pet_name
    }), 200

@app.route('/player/<int:player_id>/delete-pet/<int:pet_id>', methods=['DELETE'])
def delete_pet_from_player(player_id, pet_id):
    cursor = mysql.connection.cursor()

    query = """
        DELETE FROM Player_pet
        WHERE Player_ID = %s AND Pet_ID = %s
    """
    cursor.execute(query, (player_id, pet_id))
    mysql.connection.commit()
    cursor.close()

    return jsonify({
        "message": "Pet successfully deleted",
        "Player_ID": player_id,
        "Pet_ID": pet_id
    }), 200

@app.route('/player/<int:player_id>/update-pet/<int:pet_id>', methods=['PUT'])
def update_pet_name(player_id, pet_id):
    data = request.json
    new_pet_name = data['Pet_name']
    cursor = mysql.connection.cursor()

    query = """
        UPDATE Player_pet
        SET Pet_name = %s
        WHERE Player_ID = %s AND Pet_ID = %s
    """
    cursor.execute(query, (new_pet_name, player_id, pet_id))
    mysql.connection.commit()
    cursor.close()

    return jsonify({
        "message": "Pet name updated successfully",
        "Player_ID": player_id,
        "Pet_ID": pet_id,
        "New_Pet_name": new_pet_name
    }), 200



@app.route('/title/<int:title_id>', methods=['GET'])
def get_title_by_id(title_id):
    cursor = mysql.connection.cursor()

    query = "SELECT * FROM Titles WHERE Title_ID = %s"
    cursor.execute(query, (title_id,))
    result = cursor.fetchone()
    cursor.close()

    title = {
        "Title_ID": result[0],
        "Title_Name": result[1],
        "Title_Description": result[2]
    }

    return jsonify(title), 200

@app.route('/title', methods=['POST'])
def add_title():
    data = request.json
    title_name = data['Title_Name']
    title_description = data['Title_Description']
    cursor = mysql.connection.cursor()

    query = """
        INSERT INTO Titles (Title_Name, Title_Description)
        VALUES (%s, %s)
    """
    cursor.execute(query, (title_name, title_description))
    mysql.connection.commit()
    new_title_id = cursor.lastrowid
    cursor.close()

    return jsonify({
        "message": "Title added successfully",
        "Title_ID": new_title_id,
        "Title_Name": title_name,
        "Title_Description": title_description
    }), 200

@app.route('/title/<int:title_id>', methods=['DELETE'])
def delete_title(title_id):
    cursor = mysql.connection.cursor()

    query = "DELETE FROM Titles WHERE Title_ID = %s"
    cursor.execute(query, (title_id,))
    mysql.connection.commit()
    cursor.close()

    return jsonify({"message": "Title successfully deleted", "Title_ID": title_id}), 200


@app.route('/title/<int:title_id>/update-description', methods=['PUT'])
def update_title_description(title_id):
    data = request.json
    new_title_description = data.get('Title_Description')
    cursor = mysql.connection.cursor()

    query = """
        UPDATE Titles
        SET Title_Description = %s
        WHERE Title_ID = %s
    """
    cursor.execute(query, (new_title_description, title_id))
    mysql.connection.commit()
    cursor.close()

    return jsonify({
        "message": "Title description updated successfully",
        "Title_ID": title_id,
        "New_Title_Description": new_title_description
    }), 200






if __name__ == '__main__':
    app.run(debug=True)
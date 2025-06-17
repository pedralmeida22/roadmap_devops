import sys
from flask import Flask, jsonify, request
from bson import ObjectId
from pymongo import MongoClient, ReturnDocument

app = Flask(__name__)

try:
    mongo_client = MongoClient('mongo_db', 27017)
    print("Connected to MongoDB")
except:
    print("Could not connect to mongodb")
    sys.exit(1)

db = mongo_client['todos_db']
todos_collection = db['todos']

# get all todos
@app.route('/todos', methods=['GET'])
def todos():
    if todos_collection.count_documents({}) == 0:
        return jsonify({"message": "No TODOs"})
    all_todos = todos_collection.find()
    todos_list = [{**todo, "_id": str(todo["_id"])} for todo in all_todos]
    return jsonify(todos_list)

# create a new todo
@app.route('/todos', methods=['POST'])
def new_todo():
    data = request.get_json()
    if data is None:
        return jsonify({"message": "No data"})

    x = todos_collection.insert_one(data)
    return "Inserted new TODO: " + str(x.inserted_id)

# get a single todo by id
@app.route('/todos/<id>', methods=['GET'])
def get_todo(id):
    try:
        obj_id = ObjectId(id)
    except:
        return jsonify({"ERROR": "Invalid ID"})

    todo = todos_collection.find_one({"_id": obj_id})

    if todo is None:
        return jsonify({"message": "TODO not found"})

    todo["_id"] = str(todo["_id"])  # Convert ObjectId to string for JSON
    return jsonify(todo)

# update a single todo by id
@app.route('/todos/<id>', methods=['PUT'])
def update_todo(id):
    try:
        obj_id = ObjectId(id)
    except:
        return jsonify({"ERROR": "Invalid ID"})

    todo = todos_collection.find_one_and_update({"_id": obj_id}, {"$set": {"done": True}}, return_document=ReturnDocument.AFTER)

    if todo is None:
        return jsonify({"message": "TODO not found"})

    todo["_id"] = str(todo["_id"])  # Convert ObjectId to string for JSON
    return jsonify(todo)

# delete a single todo by id
@app.route('/todos/<id>', methods=['DELETE'])
def delete_todo(id):
    try:
        obj_id = ObjectId(id)
    except:
        return jsonify({"ERROR": "Invalid ID"})

    todos_collection.delete_one({"_id": obj_id})

    return jsonify({"message": "TODO deleted"})

# delete all documents in the database
@app.route('/todos', methods=['DELETE'])
def delete_todos():
    x = todos_collection.delete_many({})

    return jsonify({"message": "deleted {} documents".format(x.deleted_count)})


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)

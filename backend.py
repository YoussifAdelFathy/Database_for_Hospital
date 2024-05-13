from flask import Flask, render_template, request, redirect, url_for, session, flash, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from flask_mail import Mail, Message
import secrets



app = Flask(__name__, static_folder='assets', template_folder='templates')

# Database Configuration
app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+mysqlconnector://root:1234@127.0.0.1/hospitaldb"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db = SQLAlchemy(app)

# Database Models
class Doctor(db.Model):
    __tablename__ = "Doctor"
    DoctorID = db.Column(db.Integer, primary_key=True)
    Fname = db.Column(db.String(50), nullable=False)
    Lname = db.Column(db.String(50), nullable=False)
    PhoneNumber = db.Column(db.String(20), nullable=False)
    DateOfBirth = db.Column(db.Date, nullable=False)
    Gender = db.Column(db.Boolean, nullable=False)
    Specialization = db.Column(db.String(100), nullable=False)
    Salary = db.Column(db.Float, nullable=False)

class Nurse(db.Model):
    __tablename__ = "Nurse"
    NurseID = db.Column(db.Integer, primary_key=True)
    Fname = db.Column(db.String(50), nullable=False)
    Lname = db.Column(db.String(50), nullable=False)
    DateOfBirth = db.Column(db.Date, nullable=False)
    Salary = db.Column(db.Float, nullable=False)
    Gender = db.Column(db.Boolean, nullable=False)
    ShiftTiming = db.Column(db.String(100), nullable=False)

class Pharmacy(db.Model):
    __tablename__ = "Pharmacy"
    PharmacyID = db.Column(db.Integer, primary_key=True)
    StartTime = db.Column(db.Time, nullable=False)
    EndTime = db.Column(db.Time, nullable=False)
    PhoneNumber = db.Column(db.String(20), nullable=False)
    Email = db.Column(db.String(30), nullable=False)
    InventoryCapacity = db.Column(db.Integer, nullable=False)
    StaffCount = db.Column(db.Integer, nullable=False)
    # HospitalID = db.Column(db.Integer, db.ForeignKey('Hospital.HospitalID'), nullable=False)

class Medicine(db.Model):
    __tablename__ = "Medicine"
    MedicineCode = db.Column(db.Integer, primary_key=True)
    Quantity = db.Column(db.Integer, nullable=False)
    Price = db.Column(db.Integer, nullable=False)
    PharmacyID = db.Column(db.Integer, db.ForeignKey('Pharmacy.PharmacyID'), nullable=False)
    # Add a relationship to access Pharmacy information if needed
    pharmacy = db.relationship('Pharmacy', backref=db.backref('medicines', lazy=True))

class Room(db.Model):
    __tablename__ = "Room"
    RoomID = db.Column(db.Integer, primary_key=True)
    Type_ = db.Column(db.String(10), nullable=False)
    NumberOfBeds = db.Column(db.Integer, nullable=False)
    Availability = db.Column(db.Boolean, nullable=False)
    Visitability = db.Column(db.Boolean, nullable=False)
    HospitalID = db.Column(db.Integer, db.ForeignKey('Hospital.HospitalID'), nullable=False)

    # # Define a relationship to the Hospital model
    # hospital = db.relationship('Hospital', back_populates='rooms')

class Hospital(db.Model):
    __tablename__ = "Hospital"
    HospitalID = db.Column(db.Integer, primary_key=True)
    Name = db.Column(db.String(100), nullable=False)
    Address = db.Column(db.String(255), nullable=False)


class LabTechnician(db.Model):
    __tablename__ = "LabTechnician"
    TechnicianID = db.Column(db.Integer, primary_key=True)
    Fname = db.Column(db.String(20), nullable=False)
    Lname = db.Column(db.String(20), nullable=False)
    DateOfBirth = db.Column(db.Date, nullable=False)
    Gender = db.Column(db.Boolean)
    Salary = db.Column(db.Float, nullable=False)


class WardBoy(db.Model):
    __tablename__ = "WardBoy"
    WardBoyID = db.Column(db.Integer, primary_key=True)
    Fname = db.Column(db.String(50), nullable=False)
    Lname = db.Column(db.String(50), nullable=False)
    Salary = db.Column(db.Float, nullable=False)
    PhoneNumber = db.Column(db.String(20), nullable=False)
    DateOfBirth = db.Column(db.Date, nullable=False)
    Gender = db.Column(db.String(1), nullable=False)
    ShiftTiming = db.Column(db.String(50), nullable=False)


with app.app_context():
    db.create_all()



# Sercret Key
app.secret_key = secrets.token_hex(16)  

# sertting Configuration for Flask-Mail
app.config['MAIL_SERVER'] = 'smtp-mail.outlook.com' 
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USE_SSL'] = False
app.config['MAIL_USERNAME'] = 'HammadFORTEST@outlook.com' 
app.config['MAIL_PASSWORD'] = 'fA@#ewar23we978'  
# Initialize Flask-Mail
mail = Mail(app)





@app.route('/contact', methods=['POST'])
def contact_form():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        subject = request.form['subject']
        user_message  = request.form['message']

        message  = Message(subject=f'New Contact Form Submission: {subject}',
                      sender='HammadFORTEST@outlook.com',
                      recipients=['HammadFORTEST@outlook.com']) 

        message.body = f"Name: {name}\nEmail: {email}\nMessage:\n{user_message}"

        try:
            mail.send(message)
            flash('Your message has been sent. Thank you!', 'success')
        except Exception as e:
            print(e)  
            flash('An error occurred while trying to send your message. Please try again later.', 'error')

        return redirect(url_for('index'))



@app.route("/")
def index():
    return render_template("index.html")

@app.route("/index.html")
def index2():
    return render_template("index.html")

@app.route("/about.html")
def about():
    return render_template("about.html")

@app.route("/medicalstaff.html")
def medicalstaff():
    return render_template("medicalstaff.html")

@app.route("/admin.html")
def admin():
    return render_template("admin.html")

@app.route("/doctors.html")
def doctors():
    doctors = Doctor.query.all()
    return render_template("doctors.html", doctors=doctors)

@app.route("/nurse.html")
def nurses():
    nurses = Nurse.query.all()
    return render_template("nurse.html", nurses=nurses)


@app.route("/add_nurse", methods=["POST"])
def add_nurse():
    if request.method == "POST":
        data = request.get_json()
        NurseID = int(data.get("NurseID"))
        fname = data.get("Fname")
        lname = data.get("Lname")
        date_of_birth = data.get("DateOfBirth")
        salary = data.get("Salary")
        gender = bool(int(data.get("Gender")))
        shift_timing = data.get("ShiftTiming")

        new_nurse = Nurse(
            NurseID=NurseID,
            Fname=fname,
            Lname=lname,
            DateOfBirth=date_of_birth,
            Salary=salary,
            Gender=gender,
            ShiftTiming=shift_timing
        )

        db.session.add(new_nurse)
        db.session.commit()

        return jsonify(success=True)

@app.route("/remove_nurse", methods=["POST"])
def remove_nurse():
    if request.method == "POST":
        data = request.get_json()
        nurse_id = data.get("nurseId")

        # Perform the removal logic, for example:
        nurse = Nurse.query.filter_by(NurseID=nurse_id).first()
        db.session.delete(nurse)
        db.session.commit()

        # Return a response, for example:
        return jsonify(success=True)

@app.route("/medicine.html")
def medicines():
    medicines = Medicine.query.all()
    return render_template("medicine.html", medicines=medicines)

@app.route("/add_medicine", methods=["POST"])
def add_medicine():
    if request.method == "POST":
        data = request.get_json()
        medicine_code = int(data.get("MedicineCode"))
        quantity = int(data.get("Quantity"))
        price = int(data.get("Price"))
        pharmacy_id = int(data.get("PharmacyID"))

        new_medicine = Medicine(
            MedicineCode=medicine_code,
            Quantity=quantity,
            Price=price,
            PharmacyID=pharmacy_id
        )

        db.session.add(new_medicine)
        db.session.commit()

        return jsonify(success=True)

@app.route("/remove_medicine", methods=["POST"])
def remove_medicine():
    if request.method == "POST":
        data = request.get_json()
        medicine_code = data.get("medicineCode")

        # Perform the removal logic, for example:
        medicine = Medicine.query.filter_by(MedicineCode=medicine_code).first()
        db.session.delete(medicine)
        db.session.commit()

        # Return a response, for example:
        return jsonify(success=True)

@app.route("/room.html")
def rooms():
    rooms = Room.query.all()
    return render_template("room.html", rooms=rooms)


@app.route("/add_room", methods=["POST"])
def add_room():
    if request.method == "POST":
        data = request.get_json()
        RoomID = int(data.get("RoomID"))
        type_ = data.get("type_")
        numberofbeds = data.get("numberofbeds")
        availability = bool(data.get("availability"))
        visitability = bool(data.get("visitability"))
        hospitalid = data.get("hospitalid")

        new_room = Room(
            RoomID=RoomID,
            Type_=type_,
            NumberOfBeds=numberofbeds,
            Availability=availability,
            Visitability=visitability,
            HospitalID=hospitalid
        )

        db.session.add(new_room)
        db.session.commit()

        return jsonify(success=True)


@app.route("/remove_room", methods=["POST"])
def remove_room():
    if request.method == "POST":
        data = request.get_json()
        roomid = data.get("roomid")

        # Perform the removal logic, for example:
        room = Room.query.filter_by(RoomID=roomid).first()
        db.session.delete(room)
        db.session.commit()

        # Return a response, for example:
        return jsonify(success=True)




@app.route("/add_doctor", methods=["POST"])
def add_doctor():
    if request.method == "POST":
        data = request.get_json()
        DoctorID = int(data.get("DoctorID"))
        fname = data.get("fname")
        lname = data.get("lname")
        phone_number = data.get("phone_number")
        gender = bool(int(data.get("gender")))
        specialization = data.get("specialization")
        salary = data.get("salary")
        date_of_birth = "1999-01-01"

        new_doctor = Doctor(
            DoctorID = DoctorID,
            Fname = fname,
            Lname = lname,
            PhoneNumber = phone_number,
            Gender = gender,
            Specialization = specialization,
            Salary = salary,
            DateOfBirth = date_of_birth
        )

        db.session.add(new_doctor)
        db.session.commit()
        
        return jsonify(success=True)



    @app.route("/remove_doctor", methods=["POST"])
    def remove_doctor():
        if request.method == "POST":
            data = request.get_json()
            doctor_id = data.get("doctorId")

            # Perform the removal logic, for example:
            doctor = Doctor.query.filter_by(DoctorID=doctor_id).first()
            db.session.delete(doctor)
            db.session.commit()

            # Return a response, for example:
            return jsonify(success=True)

if __name__ == "__main__":
    app.run(debug=True)

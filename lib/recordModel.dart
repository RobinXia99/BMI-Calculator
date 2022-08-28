class Record {
  String gender;
  String height;
  String weight;
  String bmi;
  String date;




  Record(this.gender, this.height, this.weight, this.bmi, this.date);

  String toString() {
    return '{ ${this.gender}, ${this.height}, ${this.weight}, ${this.bmi}, ${this.date} }';
  }
}
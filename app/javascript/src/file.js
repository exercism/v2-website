class File {
  constructor(filename, content) {
    this.filename = filename;
    this.content = content;
    this.database = localStorage;
  }

  saveLocalChange(value) {
    this.database.setItem(this.filename, value);
  }

  getContent() {
    return this.database.getItem(this.filename) || this.content;
  }

  reset() {
    this.database.removeItem(this.filename);
  }
}

export default File;

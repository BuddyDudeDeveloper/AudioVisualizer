//The text that displays information to the user.
class Text implements Drawable {

  //The text as a collection of characters.
  private char[] _value = "".toCharArray();
  
  //The location of the text in the sketch.
  private PVector _position = new PVector();
  
  //The size of the font.
  private int _size = 24;
  
  //The amount of characters to be displayed. Prevents overlap with the shapes.
  private int _characterLimit = 20;
  
  //The opacity of the text.
  private float _opacity = 255;
  
  //
  private color _fill = 0;
  
  //Displays the text.
  public void draw() {
    
    //Fetches the number of characters in the string.
    int length = _value.length;
    
    //Sets the color to whatever the accent color is.
    fill(_fill != 0 ? _fill : Colors.getAccentColor(), _opacity);
    
    //Displays the text at its designated size.
    textSize(_size);
    
    //Displays the text with the character limit in mind.
    text(_value, 0, length < _characterLimit ? length : _characterLimit, _position.x, _position.y);
  }
  
  //Setter for the text to be displayed.
  public void setValue(String value) {
    _value = value.toCharArray();
  }
  
  //Setter for the location of the text in the sketch.
  public void setPosition(PVector value) {
    _position.set(value);
  }
  
  //Setter for the font size.
  public void setSize(int value) {
    _size = value;
  }
  
  //Setter for the opacity.
  public void setOpacity(float value) {
    _opacity = value;
  }
  
  //Getter for the opacity.
  public float getOpacity() {
    return _opacity;
  }
  
  //Getter for the text as a string.
  public String getValue() {
    return new String(_value);
  }
  
  //Setter for the fill color.
  public void setFill(color value) {
    _fill = value;
  }
  
  //Getter for the fill color.
  public color getFill() {
    return _fill;
  }
  
  //Setter for the amount of characters to be displayed. Prevents overlap with the shapes.
  public void setCharacterLimit(int value) {
    _characterLimit = value;
  }
}

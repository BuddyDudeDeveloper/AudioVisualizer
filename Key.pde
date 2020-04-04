//A visual indicator of the available inputs a user can perform.1
class Key implements Drawable {

  //The size of the framing rectangle.
  private PVector _size = new PVector(25, 25);
  
  //The position of the indicator.
  private PVector _position = new PVector();
  
  //The text of the keyboard key associated with the input.
  private Text _key = new Text();
  
  //The text of the action associated with the input.
  private Text _action = new Text();
  
  //The interpolation of the fill and stroke colors.
  private float _feedbackLerp = 0;
  
  //The change in time between frames.
  private float _deltaTime = 0;
  
  //The time of the previous frame.
  private float _previousTime = 0;
  
  //Class constructor.
  Key() {
    
    //Sets the font size of the in-indicator text to 14.
    _key.setSize(14);
    
    //Sets the font size of the associated action text to 11.
    _action.setSize(11);
  }
  
  //Displays the frame and text.
  public void draw() {
    
    
    //Calculate the fill and stroke colors.
    color textAndStrokeColor = lerpColor(Colors.getAccentColor(), Colors.getBackgroundColor(), _feedbackLerp);
    
    //Calculate the change in timer between frames.
    _deltaTime = (millis() - _previousTime) / 250;
      
      //Fill the shapes with the interpolated color.
      fill(lerpColor(Colors.getBackgroundColor(), Colors.getAccentColor(), _feedbackLerp));
      
      //Also fill the text.
      _key.setFill(textAndStrokeColor);
      
      //Update the stroke color.
      stroke(textAndStrokeColor);
    
    
    //If the mouse is overlapping the indicator...
    if(mouseIsOverlapping()) {
      
      
      //Increment the interpolation but cap it at 1.
      if(_feedbackLerp < 1) _feedbackLerp += _deltaTime;
      else _feedbackLerp = 1;
      
      
    } 
    
    //Otherwise...
    else {
      
      //Fade out the interpolation.
      _feedbackLerp *= .95;
      
    }
    
    //Sets the stroke weight to 1.
    strokeWeight(1);
    
    //Draws a rectangle at the specified location with the specified size.
    rect(_position.x, _position.y, _size.x, _size.y);
    
    //Displays the text of the indicator.
    drawText();
    
    //Fetches the time at the end of the frame.
    _previousTime = millis();
  }
  
  //Displays the text of the indicator.
  private void drawText() {
    _key.draw();
    _action.draw();
  }

  //A combined setter for the text of the visual indicator.
  //String key is the text to be displayed inside the key.
  //String action is the text to be displayed below the indicator.
  public void setText(String key, String action) {
    _key.setValue(key);
    _action.setValue(action);
  }
  
  //Setter for the size of the frame.
  public void setSize(PVector value) {
    _size.set(value);
  }
  
  //Setter for the position of the frame and associated text.
  public void setPosition(PVector value) {
    _position.set(value);
    _key.setPosition(new PVector(_position.x, _position.y + 5));
    _action.setPosition(new PVector(_position.x, _position.y + _size.y + 1));
  }
  
  //Uses AABB to determine if the box bar of the indicator is being hovered over.
  public boolean mouseIsOverlapping() {
    
    //Half the width.
    float halfWidth = _size.x/2;
    
    //Half the height.
    float halfHeight = _size.y/2;
    
    //Location of the left side in the sketch.
    float left = _position.x - halfWidth;
    
    //Location of the right side in the sketch.
    float right = _position.x + halfHeight;
    
    //Location of the top side in the sketch.
    float top = _position.y - halfHeight;
    
    //Location of the bottom side in the sketch.
    float bottom = _position.y + halfHeight;
    
    //If the mouse is not inside the box, return false. Otherwise, return true.
    if(mouseX > right) return false;
    else if(mouseX < left) return false;
    else if(mouseY > bottom) return false;
    else if(mouseY < top) return false;
    else return true;
    
  }
  
}

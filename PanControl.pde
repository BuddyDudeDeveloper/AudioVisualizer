//A UI element for controlling the direction of the audio.
class PanControl implements Drawable {
 
  //The rotation of the shape.
  private float _rotation = 0;
  
  //The shape's size.
  private final int SIZE = 25;
  
  //The location of the element in the sketch.
  private final PVector _position = new PVector();
  
  //The location of the mouse in the sketch.
  private final PVector _mousePosition = new PVector();
  
  //A flag to see if the user clicked on the element.
  private boolean _clickedOn = false;
  
  //The text that describes the pan controller's action.
  private final Text _text = new Text();
  
  //The interpolation of the fill and stroke colors.
  private float _feedbackLerp = 0;
  
  //The change in time between frames.
  private float _deltaTime = 0;
  
  //The time on the previous frame.
  private float _previousTime = 0;
  
  //Class constructor
  PanControl() {
    
    //Sets the font size and text to describe its action.
    _text.setValue("L/R");
    _text.setSize(11);
  }
  
  //Displays all subcomponents of the element and updates values once per frame.
  public void draw() {
    
    //Updates the mouse position.
    updateMousePosition();
    
    //Changes the rotation and pan value if the user is clicking on it.
    handleInteraction();
    
    //Draws the graphical components of the shape.
    drawShapes();
    
    //The time of the previous frame.
    _previousTime = millis();
  }
  
  //Checks if the user is clicking and updates the rotation of the shape and panning of the audio.
  private void handleInteraction() {
    
    //If the mouse is over the pan control or the user is still holding down the left mouse button...
    if(isOverlapping() || _clickedOn) {
      
      //Calculate the change in time between frames.
      _deltaTime = (millis() - _previousTime) / 250;
      
      //Use that to interpolate the fill and stroke.
      _feedbackLerp += _deltaTime;
    }
    
    //Otherwise...
    else {
      
      //Fades the interpolation back to normal.
      _feedbackLerp *= .95;
    }
    
    //If the user clicked on the shape...
    if(mousePressed && mouseButton == LEFT && _clickedOn) {
      
      //Rotate it between -90 and 90 degrees.
       _rotation = map(mouseX, _position.x - SIZE, _position.x + SIZE, -HALF_PI, HALF_PI);
       
       //Clamp the rotation between -90 and 90.
       if(_rotation < -HALF_PI) _rotation = -HALF_PI;
       else if(_rotation > HALF_PI) _rotation = HALF_PI;
       
       //Map the rotate to the left and right values of audio pan.
       Audio.setPan(map(_rotation, -HALF_PI, HALF_PI, -1, 1));
    }
  }
  
  //Displays the graphical elements of the shape.
  private void drawShapes() {
    
    //Only displays the outlines of the shapes.
    noFill();
    stroke(lerpColor(Colors.getAccentColor(), Colors.getBackgroundColor(), _feedbackLerp));
    fill(lerpColor(Colors.getBackgroundColor(), Colors.getAccentColor(), _feedbackLerp));
    
    //BEGIN MATRIX
    pushMatrix();
    
    //Moves the shape to the desired location.
    translate(_position.x, _position.y);
    
    //Rotates the shape.
    rotate(_rotation);
    
    //Draws the circular frame and the line from the center to the edge of the circle.
    circle(0, 0, SIZE);
    line(0, 0, 0, -SIZE/2);
    
    //END MATRIX
    popMatrix();
    
    //Displays the action text.
    _text.draw();
  }
  
  //Updates the mouse position and stores it in a vector used for calcuating the distance between it and the UI element.
  private void updateMousePosition() {
    _mousePosition.set(mouseX, mouseY);
  }
  
  
  //Setter for the position of the shape in the sketch. Also updates text location.
  public void setPosition(PVector value) {
    _position.set(value);
    _text.setPosition(new PVector(_position.x, _position.y + SIZE + 1));
  }
  
  //Setter for the clicked on flag.
  public void setClickedOn(boolean value) {
    _clickedOn = value;
  }
  
  //Calculates the distance between the mouse and the element to determine if the mouse is on top of it.
  public boolean isOverlapping() {
     return _mousePosition.dist(_position) < SIZE/2;
  }
}

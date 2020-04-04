//A visual indicator for percentage-based values.
class InformationBar implements Drawable {
  
  //The location of the element in the sketch.
  private final PVector _position = new PVector(width - 125, 50);
  
  //The size of the frame the bar is in.
  private final PVector _frameSize = new PVector(10, 75);
  
  //The size of the bar itself, tied to percetages.
  private final PVector _barSize = new PVector(10, 25);
  
  //The percent displayed as readable text.
  private final Text _percentText = new Text();
  
  //The descriptor of what the indictator describes.
  private final Text _label = new Text();
  
  //The size of the font.
  private final int FONT_SIZE = 14;
  
  //Class constructor.
  InformationBar() {
    
    //Set up the percent text.
    _percentText.setPosition(new PVector(_position.x + 5, _position.y + _frameSize.y + 25));
    _percentText.setSize(FONT_SIZE);
    _percentText.setValue("50%");
    _percentText.setOpacity(0);
    
    //Set up the label text.
    _label.setPosition(new PVector(_position.x + 5, _position.y - 10));
    _label.setSize(FONT_SIZE);
    _label.setValue("Volume");
  }
 
  public void draw() {
    
    //Draw the rectangle from the corner for height effect.
    rectMode(CORNER);
    
    //BEGIN MATRIX
    pushMatrix();
    
    //Move the indicator to the desired position.
    translate(_position.x, _position.y);
    
    //Display the frame.
    drawFrame();
    
    //Display the percentage bar.
    drawBar();
    
    //END MATRIX
    popMatrix();
    
    //Displays the test.
    drawText();
    
    
    //Resets rectangle draw mode back to center
    rectMode(CENTER);
  }
  
  //Draws the outside rectangle.
  private void drawFrame() {
    
    //No fill and stroke to create frame effect.
    noFill();
    stroke(Colors.getAccentColor());
    rect(0, 0, _frameSize.x, _frameSize.y);
  }
  
  //Draws the inside (percentage-driven) rectangle.
  private void drawBar() {
    
    //BEGIN MATRIX
    pushMatrix();
    
    //Rotates it -90 degrees to when height changes, the bottom corners do not move.
    rotate(-1 * HALF_PI);
    
    //Fills the draws the percent bar.
    fill(Colors.getAccentColor());
    rect(-1 * _frameSize.y, 0, _barSize.y, _barSize.x);
    
    //END MATRIX
    popMatrix();
  }
  
  //Displays the current percentage.
  void drawText() {
    
    //Copies the value of the text's opacity so it will 
    float opacity = _percentText.getOpacity();
    
    //Fade the text out. If the opacity is less than one, force it to 0.
    _percentText.setOpacity(opacity > 1 ? opacity * .99 : 0);
    
    //Draws the percent text.
    _percentText.draw();
    
    //Displays the description.
    _label.draw();
  }
  
  //Updates the values in the object.
  public void update(float value) {
    
      //Maps the percent from the value's range.
      int percent = (int)map(value, -50, 50, 0, 100);
            
      //Maps the actual value to percentages displayed to the user.
      _percentText.setValue(Integer.toString(percent) + "%");
      
      //Makes the text visible.
      _percentText.setOpacity(255);
      
      //Maps the height to the percentage.
      _barSize.y = map(percent, 0, 100, 0, _frameSize.y);
  }
  
  //Sets the description text.
  public void setLabel(String value) {
    _label.setValue(value);
  }
  
  //Sets the position of the element in the sketch.
  public void setPosition(PVector value) {
    
    //In addition to updating the position of the whole object, the positions of the text are updated as well.
    _position.set(value);
    _label.setPosition(new PVector(_position.x + 5, _position.y - 10));
    _percentText.setPosition(new PVector(_position.x + 5, _position.y + _frameSize.y + 25));
  }
}

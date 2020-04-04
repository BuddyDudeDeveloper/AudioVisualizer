//Static class for managing the different colors in the sketch.
static class Colors {
  
  //The dark blue used as a background and accent color.
   public static final color DARK_BLUE = #000814;
   
   //The light blue used as a background and accent color.
   public static final color LIGHT_BLUE = #c7c2f8;
   
   //The light green used as a background and accent color.
   public static final color LIGHT_GREEN = #99CC14;
   
   //The dark green used as a background and accent color.
   public static final color DARK_GREEN = #0C0F02;
   
   //The light orange used as a background and accent color.
   public static final color LIGHT_ORANGE = #feb19d;
   
   //The dark orange used as a background and accent color.
   public static final color DARK_ORANGE = #200700;
   
   //The index of the current color scheme.
   private static int _currentColor = 0;
   
   //A list of all available colors.
   private static final color[][] _colors = {{DARK_BLUE, LIGHT_BLUE}, {DARK_GREEN, LIGHT_GREEN}, {DARK_ORANGE, LIGHT_ORANGE}, {LIGHT_BLUE, DARK_BLUE}, {LIGHT_GREEN, DARK_GREEN}, {LIGHT_ORANGE, DARK_ORANGE}};
   
   //The total amount of available color schemes.
   private static final int NUMBER_OF_COLORS = _colors.length;
   
   //The current background color.
   private static color _background = DARK_BLUE; 
   
   //The current accent color.
   private static color _accent = LIGHT_BLUE;
   
   //Getter for the current background Color.
   public static color getBackgroundColor() {
     return _background;
   }
   
   //Setter for the current background value.
   public static void setBackgroundColor(color value) {
     _background = value;
   }
   
   //Getter for the current accent color.
   public static color getAccentColor() {
     return _accent;
   }
   
   //Setter for the current accent color.
   public static void setAccentColor(color value) {
     _accent = value;
   }
   
   //Changes the color scheme.
   //boolean forward determines if the user is moving forward in their color selection or backwards.
   public static void changeColors(boolean forward) {
     
     //Moves color scheme forward or backward based on argument.
     _currentColor += forward ? 1 : -1;
     
     //If the user goes backwards too much, go to the last possible scheme.
     if(_currentColor < 0) _currentColor = NUMBER_OF_COLORS - 1;
     
     //Increments and resets the index based on the current color selection.
     int index = _currentColor % NUMBER_OF_COLORS;
     
     //Fetches the paired colors.
     color[] colors = _colors[index];
     
     //The background color is always the first in the array.
     _background = colors[0];
     
     //The accent color is always the second in the array.
     _accent = colors[1];
   }
}

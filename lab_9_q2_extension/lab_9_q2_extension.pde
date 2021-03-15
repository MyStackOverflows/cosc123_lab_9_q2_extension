// after reading the website below and experimenting a bit, i wanted to see how many wacky shapes i could find. so i wrote this program.
// http://paulbourke.net/geometry/supershape/
// i found the whole thing worked better when m1 == m2, so i just made one value m

final float m_MAX = 50, n1_MAX = 50, n2_MAX = 20, n3_MAX = 20;
float a, b, m, n1, n2, n3;
float scale;
void setup()
{
  size(800, 830);  // make taller so that text can fit without ever overlapping with actual drawing
  strokeWeight(2);
  colorMode(HSB, 360, 100, 100);
  randomizeValues();
}

void draw()
{
  background(0);
  textAlign(LEFT, TOP);
  text(String.format("a: %f, b: %f, m: %f, n1: %f, n2: %f, n3: %f, scale: %f", a, b, m, n1, n2, n3, scale), 0, 0);
  text("use SPACE to randomize; use a & d to change n2; use w & s to change n3; use mouseX to change m and mouseY to change n1", 0, 15);
  translate(width / 2, height / 2 + 15);  // translate so that the sketch won't overlap with text
  supershape();//(a, b, m1, m2, n1, n2, n3);
  
  // update some variables with mouseX and mouseY
  m = map(mouseX, 0, width, 0, n1_MAX);
  n1 = map(mouseY, 0, height, 0, m_MAX);
}

void supershape()
{
  // calculate largest radius to make a scale such that the entire sketch will fit within the frame
  float largestR = 0;
  for (float i = 0; i < 360; i += 0.0625)
  {
    float r = calcR(i);
    if (r > largestR) largestR = r;
  }
  scale = width / largestR / 2;  // the 2 is there because otherwise it would calculate the width of the sketch as the radius, and instead we want the diameter to fit within the sketch
  
  // main draw loop
  for (float i = 0; i < 360; i += 0.0625)
  {
    stroke(i, 100, 100);                                              // make the shape have gradient colours
    float r = calcR(i);                                               // calculate r
    point(scale * r * cos(radians(i)), scale * r * sin(radians(i)));  // calculate x and y of point based on r and theta
  }
}

// this function calculates the radius with the supershape formula
float calcR(float degrees)
{ return pow((pow(abs(cos(m * radians(degrees) / 4) / a), n2) + pow(abs(sin(m * radians(degrees) / 4) / b), n3)), -1 / n1); }

// i put the randomize key here so that it wouldn't repeat as fast as the WASD keys
void keyTyped()
{ if (key == ' ') randomizeValues(); }

void keyPressed()
{
  if (key == 'd') n2 = n2 < n2_MAX ? n2 + 0.1 : n2_MAX;
  if (key == 'a') n2 = n2 > 0 ? n2 - 0.1 : 0;
  if (key == 'w') n3 = n3 < n3_MAX ? n3 + 0.1 : n3_MAX;
  if (key == 's') n3 = n3 > 0 ? n3 - 0.1 : 0;
}

// change all values to something random (values for random() were just trial and error until i found a combination that makes interesting shapes, as well as using some info from the website cited above)
void randomizeValues()
{
  a = random(1, 10); b = random(1, 10);              // changing a and b just seems to affect scale, but why not change them for extra randomness?
  m = random(0, m_MAX);                              // the greater m is, the more points the shape seems to have
  n1 = random(0, n1_MAX);                            // the greater n1 is, the more bloated the shape is. the smaller it is, the more pinched it seems
  n2 = random(0, n2_MAX); n3 = random(0, n3_MAX);    // n2 and n3 seem to change the distance between points? but i'm not sure
}

int x = 150; 
int sliderNum = 0;
int textNum = 0;

int[] pointerXpos = new int [9];
int[] sliderYpos = new int [9];

int sliderStart = 150;
int sliderLength = 275;
int xWid = sliderStart + sliderLength;

int[] weeks = new int[15];

int[] credits = new int[15];
int[] classHours = new int[15];
int[] workHours = new int[15];
int[] engagementHours = new int[15];
int[] studyAloneHours = new int[15];
int[] groupStudyHours = new int[15];
int[] resourceHours = new int[15];
int[] leisureHours = new int[15];
int[] sleepHours = new int[15];

int[] happiness = new int[15];
int[] gradePotential = new int[15];
int[] wealth = new int[15];

int totalHappiness;
int totalGrades;
int totalWealth;

int random1;
int random2;

int curWeek = 0;

boolean errorChecker;

String[] text = {
  "CREDITS", "CLASS HOURS", "JOB HOURS", 
  "CLASS ENGAGEMENT (%)", "STUDY ALONE HOURS", 
  "GROUP STUDY HOURS", "RESOURCE HOURS", "LEISURE HOURS", 
  "SLEEP HOURS"
};

void setup() {
  size(1000, 1000);
  for (int i = 0; i < 15; i++) {
    happiness[i] = 50;
    gradePotential[i] = 90;
    wealth[i] = 0;
    weeks[i] = i+1;
    if (i < pointerXpos.length) {
      pointerXpos[i] = x;
      sliderYpos[i] = 225 + 50*i;
    }
  }
}

void draw() {
  background(255);
  fill(120, 0, 120);

  errorCheck();
  drawText();
  movePointer();
  drawSlider();
  clearButton();
  submitButton();
  drawGraphs();
  cumulativeTotals();
}

void drawSlider() {
  for (int i = 250; i <= 650; i += 50) {
    sliderNum = (i - 225) / 50;
    line(sliderStart + 25, i, xWid, i);
    ellipse(pointerXpos[sliderNum] + 25, i, 15, 15);
  }
}

void movePointer() {
  for (int yPos = 225; yPos <= 625; yPos += 50) {
    sliderNum = (yPos - 225) / 50;
    if (mousePressed) {
      if (mouseY > yPos && mouseY < yPos + 50) {
        sliderYpos[sliderNum] = constrain(mouseX, x, 400);
        pointerXpos[sliderNum] = sliderYpos[sliderNum];
      }
    }
  }
}

void drawText() {
  text("CURRENT WEEK: " + (curWeek+1), 300, 170);
  for (int i = 250; i <= 650; i += 50) {
    textAlign(RIGHT);
    textNum = (i - 250) / 50;
    text(text[textNum], x, 254+(50*textNum));
  }

  text(happiness[0], 500, 500);
  text(wealth[0], 500, 600);
  text(gradePotential[0], 500, 700);

  textAlign(LEFT);
  text(int(((pointerXpos[0] - x)) / 20) + 12, 450, 254);    // Credits
  text(int(((pointerXpos[1] - x)) / 10.2), 450, 304);       // Class Hours
  text(int(((pointerXpos[2] - x)) / 6.2), 450, 354);        // Job Hours
  text(int(((pointerXpos[3] - x)) / 3.55)+20, 450, 404);    // Class Engagement %
  text(int(((pointerXpos[4] - x)) / 3.46), 450, 454);       // Study Alone Hours
  text(int(((pointerXpos[5] - x)) / 5.2), 450, 504);        // Group Study Hours
  text(int(((pointerXpos[6] - x)) / 20.4), 450, 554);       // Resource Hours
  text(int(((pointerXpos[7] - x)) / 2.75), 450, 604);       // Leisure Hours
  text(int(((pointerXpos[8] - x)) / 3.02) + 8, 450, 654);   // Sleep Hours
}

void clearButton() {
  rect(100, 100, 100, 100);
  fill(255);
  text("CLEAR ALL", 120, 160);
  if (mousePressed) {
    if (mouseX > 100 && mouseX < 200 && mouseY > 100 && mouseY < 200) {
      for (int i = 250; i <= 650; i += 50) {
        sliderNum = (i - 250) / 50;
        pointerXpos[sliderNum] = x;
      }
    }
  }
}

void submitButton() {
  fill(120, 0, 120);
  rect(500, 100, 100, 100);
  fill(255);
  text("SUBMIT THIS", 515, 145);
  text("WEEK'S DATA", 513, 165);
}

void mouseClicked() {
  if (mouseX > 500 && mouseX < 600 && mouseY > 100 && mouseY < 200 && errorChecker == false) {
    classHours[curWeek] = int(((pointerXpos[1] - x)) / 6.2);
    workHours[curWeek] = int(((pointerXpos[2] - x)) / 3.55) + 20;
    engagementHours[curWeek] = int(((pointerXpos[3] - x)) / 10.2);
    studyAloneHours[curWeek] = int(((pointerXpos[4] - x)) / 3.46);
    groupStudyHours[curWeek] = int(((pointerXpos[5] - x)) / 5.2);
    resourceHours[curWeek] = int(((pointerXpos[6] - x)) / 20.4);
    leisureHours[curWeek] = int(((pointerXpos[7] - x)) / 2.87) + 8;
    sleepHours[curWeek] = int(((pointerXpos[8] - x)) / 3.02) + 8;
    calculations();
    curWeek++;
  }
}

void calculations() {
  if (credits[curWeek] > 12) {
    happiness[curWeek] -= (((credits[curWeek] - 12)%4) * .5);
  }

  if (engagementHours[curWeek] < 80) {
    happiness[curWeek] += 2*(credits[curWeek] - (engagementHours[curWeek] * credits[curWeek]));
  }

  if (studyAloneHours[curWeek] > 35) {
    happiness[curWeek] -= ((studyAloneHours[curWeek] - 35) * .05);
  }

  happiness[curWeek] += (groupStudyHours[curWeek] * .05);

  random1 = int(random(0, 1));

  if (random1 == 0) {
    happiness[curWeek] -= (resourceHours[curWeek]%2 * .02);
  } else {
    happiness[curWeek] += (resourceHours[curWeek]%2 * .02);
  }

  if (sleepHours[curWeek] < 28) {
    happiness[curWeek] -= (happiness[curWeek] * .25);
  }

  if (sleepHours[curWeek] <= 63 && sleepHours[curWeek] >= 35) {
    happiness[curWeek] += (sleepHours[curWeek]%7 * .05);
  }

  happiness[curWeek] += (leisureHours[curWeek] * .025);

  if (leisureHours[curWeek] >=40) {
    happiness[curWeek] -= ((leisureHours[curWeek] - 40) * .025);
  }

  gradePotential[curWeek] += ((.05 * (classHours[curWeek] - credits[curWeek])) + (.001 * classHours[curWeek]));

  if (credits[curWeek] > 12) {
    gradePotential[curWeek] -= ((credits[curWeek] - 12) * .015);
  }

  gradePotential[curWeek] -= (workHours[curWeek] * .005);

  if (engagementHours[curWeek] < 80) {
    gradePotential[curWeek] -= 2*(credits[curWeek] - (engagementHours[curWeek] * credits[curWeek]));
  }

  if (studyAloneHours[curWeek] <= 35) {
    gradePotential[curWeek] += pow(.0108, studyAloneHours[curWeek]);
  } else {
    gradePotential[curWeek] += pow(.0108, studyAloneHours[curWeek]);
    gradePotential[curWeek] += pow(.005, studyAloneHours[curWeek]-35);
  }

  random2 = int(random(0, 99));

  if (random2 >= 0 && random2 <= 14) {
    gradePotential[curWeek] -= (.02 * groupStudyHours[curWeek]);
  } else {
    gradePotential[curWeek] += (.02 * groupStudyHours[curWeek]);
  }

  gradePotential[curWeek] += (resourceHours[curWeek] * .03);

  if (sleepHours[curWeek] < 28) {
    gradePotential[curWeek] -= (gradePotential[curWeek] * .25);
  }

  if (leisureHours[curWeek] >= 40) {
    gradePotential[curWeek] -= ((leisureHours[curWeek] - 40) * .01);
  }

  wealth[curWeek] += 7 * workHours[curWeek];

  if (sleepHours[curWeek] < 28) {
    wealth[curWeek] -= (wealth[curWeek] * .25);
  }

  if (happiness[curWeek] > 100) {
    happiness[curWeek] = 100;
  } else if (happiness[curWeek] < 0) {
    happiness[curWeek] = 0;
  }

  if (gradePotential[curWeek] > 100) {
    gradePotential[curWeek] = 100;
  } else if (gradePotential[curWeek] < 0) {
    gradePotential[curWeek] = 0;
  }
}

void drawGraphs() {
  // Working line graphs are currently being worked on and will be presented for the next deliverable
  
  line(700, 150, 700, 250); // Line to create graph 1, y-axis
  line(700, 250, 800, 250); // Line to create graph 1, x-axis

  line(700, 250, 730, 235); // Hardcoded lines for the demo
  line(730, 235, 760, 200);
  line(760, 200, 790, 150);
  line(790, 150, 800, 230);

  line(700, 350, 700, 450); // Line to create graph 2, y-axis
  line(700, 450, 800, 450); // Line to create graph 2, x-axis

  line(700, 450, 730, 435); // Hardcoded lines for the demo
  line(730, 435, 760, 400);
  line(760, 400, 790, 350);
  line(790, 350, 800, 430);

  line(700, 550, 700, 650); // Line to create graph 3, y-axis
  line(700, 650, 800, 650); // Line to create graph 3, x-axis

  line(700, 650, 730, 635); // Hardcoded lines for the demo
  line(730, 635, 760, 600);
  line(760, 600, 790, 550);
  line(790, 550, 800, 630);
}

void cumulativeTotals() {
  for (int l = 0; l < 15; l++) {
    totalHappiness += happiness[l];
    totalGrades += gradePotential[l];
    totalWealth += wealth[l];
  }

  if (curWeek >= 14) {
    curWeek = 14;
  }

  if (curWeek == 14) {
    totalHappiness = totalHappiness/15;
    totalGrades = totalGrades/15;
    println("Congradulations! You completed the school semester!");
    println("Your total Happiness is: " + totalHappiness);
    println( "Your total GPA is: " + totalGrades);
    println("Your total Wealth is: " + totalWealth);
    noLoop();                                                        
    
  }
}

void errorCheck() {
  if ((int(((pointerXpos[1] - x)) / 6.2)) + (int(((pointerXpos[2] - x)) / 3.55) + 20) + (int(((pointerXpos[4] - x)) / 3.46))
    + (int(((pointerXpos[5] - x)) / 5.2)) + (int(((pointerXpos[6] - x)) / 20.4)) + (int(((pointerXpos[7] - x)) / 2.87) + 8)
    + (int(((pointerXpos[8] - x)) / 3.02) + 8) >= 169) {
    errorChecker = true;
  } else {
    errorChecker = false;
  }
  if (errorChecker == true) {
    fill(120, 0, 120);
    text("ERROR: TOO MANY HOURS", 600, 500);
  }
}


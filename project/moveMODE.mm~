
/*denote how many block have been stacked*/
blocks = 0;

/*denote current height of stack, may need adjustment*/
height = 0.3;

/*drop locations*/
dropX = to_float(40);
dropY = to_float(40);


function move_arm_mode(mode)
	"Move the arm to the specified location for stacking and stack drop the Jenga block in place"
{


/*if mode 1, stack normally*/
if(mode == 1)
{

/*stack block in given location*/
move_arm(dropX, dropY, height);
	sleep(3);
	servo_open(50);


height = height + 1.5;
blocks = blocks + 1;

/*run mode 1*/
}


/*******************************************************************/



else if(mode == 2)
{
	/* run mode 2*/

/*if first block*/
if(blocks == 0)
{
	move_arm(dropX, dropY, height);
	sleep(3);
	servo_open(50);
};

/*if second block*/
if(blocks ==1)
{
	move_arm(dropX + 2.5, dropY, height);
	sleep(3);
	servo_open(50);
};

/*if third block*/
if(blocks ==2)
{
	move_arm(dropX - 2.5, dropY, height);
	sleep(3);
	servo_open(50);
	height = height + 1.5;
};

/*if fourth block*/
if(blocks ==3)
{
	move_arm(dropX, dropY, height);
	/*turn 90 degrees*/
	
	sleep(3);
	servo_open(50);
};

/*if fifth block*/
if(blocks ==4)
{
	move_arm(dropX, dropY + 2.5, height);
	/*turn 90 degrees*/
	
	sleep(3);
	servo_open(50);
};

/*if sixth block*/
if(blocks ==5)
{
	move_arm(dropX, dropY + 5.0, height);
	/*turn 90 degrees*/
	
	sleep(3);
	servo_open(50);
	height = height + 1.5;
	blocks = -1;
};


blocks = blocks + 1;

/*mode 2*/
};
/*move arm mode*/
};

function move_arm(x, y, &optional gripper &init "default")
	"Move the gripper to the location specified and either open or close the hand.	The coordinates are in a right handed coordinate system. :param x: x location on the table from the base of the arm.	:param y: y location on the table from the base of the arm.	:param gripper: Specify to 'open' or 'close' the gripper."
{

z = 0;
a2 = 25.5;
a3 = 25.5;

/*get magnitudes*/
r = sqrt(x^2 + y^2 + z^2);
r_xy = sqrt(x^2 + y^2);

/*find theta3 rotate second arm joint*/
theta3 = (180/PI) * acos((r^2 - a2^2 - a3^2)/(2*a2*a3));

/*find phi*/
phi = (180/PI) * atan((a3 * sin((PI/180)*theta3))/(a2+a3*cos((PI/180)*theta3)));

/*find alpha*/
alpha = (180/PI) * acos(r_xy/r);

/*find theta2 rotate first arm joint*/
theta2 = phi - alpha;

/*find theta4: rotate hand*/
theta4 = 90 + (theta2 - theta3);

/*find theta1: rotate arm body*/
theta1 = (180/PI) * atan((y+ 0.0)/x);

/*theta5 is zero since we do not require any rotation at that joint*/
theta5 = 0.0;

if(theta1 >= -125 && theta1 <= 125 && theta2 >= 0 && theta2 <= 90 && theta3 >= 0 && theta3 <= 120 && theta4 >= 0 && theta4 <= 100 && !isnan(theta1) && !isnan(theta2) && !isnan(theta3) && !isnan(theta4))
{
	rob_move_abs(theta1, theta2, theta3, theta4, theta5);
	sleep(3);
	if(gripper == "close"){
		servo_close(50);
	};
	if(gripper == "open"){
		servo_open(50);
	};
}
else
{
	printf("Please enter a value location");
};

values = make_array(5, 0);
values[1] = theta1;
values[2] = theta2;
values[3] = theta3;
values[4] = theta4;
values[5] = theta5;
values;
};


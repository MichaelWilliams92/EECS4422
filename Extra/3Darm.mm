function move_arm(x, y, z, &optional gripper &init "default")
	"Move the gripper to the location specified and either open or close the hand.	The coordinates are in a right handed coordinate system. :param x: x location on the table from the base of the arm.	:param y: y location on the table from the base of the arm. :param z: z location on the table from the base of the arm.	:param gripper: Specify to 'open' or 'close' the gripper."
{

/*get calulations for angles*/

/*given information*/

L1 = 25.5;
L2 = 25.5;
L3 = 5.0;
base = 8.0;

/*check inputs*/

if(y < 0)
{
	printf("sorry, y values may not be negative"); 
} else if(y == 0) 
{
	if(x == 0){printf("cannot use origin as a point");};
	if(x < 0){theta1 = -90.0;
		  radius = sqrt(x^2 + y^2);};	
	if(x > 0){theta1 = 90.0;
		  radius = sqrt(x^2 + y^2);};
		
} else if(x == 0) {theta1 = 0.0;
		   radius = sqrt(x^2 + y^2);} 

else {


/*first, compute radius and its angle with given (x,y) coordinate*/

radius = sqrt(x^2 + y^2);
theta1 = (180.0/PI) * atan((y + 0.0)/(x + 0.0));
printf("radius= %f, angle = %f", radius, theta1); 

};

/*continue only if y is >= 0*/

if(y<0 || (x==0 && y==0) ) 
{
	printf("invalid points given");
} else {

/*get p3 point.  radius will be new y value*/

/*if z is above base, calculate z length as such*/
if(z >= 8)
{
	p3z = z + L3 - 8;
	p3y = radius;
	printf("p3y = %f, p3z = %f", p3y, p3z); 
}

/*if z is below base, calculate z length as such*/
else {

	p3z = 8 - (z + L3);
	p3y = radius;

};

/*compute partial angles */

hypT = sqrt(p3y^2 + p3z^2);
theta2A = (180/PI) * atan(p3z/p3y);
theta4A = 180 - 90 - theta2A;
printf("theta2A = %f, theta4A = %f", theta2A, theta4A); 

theta2B = (180/PI) * acos((L1^2 + hypT^2 - L2^2) / (2 * L1 * hypT));
theta3A = (180/PI) * acos((L1^2 + L2^2 - hypT^2) / (2 * L1 * L2));
theta4B = (180/PI) * acos((L2^2 + hypT^2 - L1^2) / (2 * L2 * hypT));
printf("theta2B = %f, theta3A = %f, theta4B = %f", theta2B, theta3A, theta4B); 

/*compute final angles*/

/*if z is above base, calculate angles as such*/
if(z >= 8)
{

	theta2 = theta2A + theta2B;
	theta3 = 180 - theta3A;
	theta4 = 180 - theta4A - theta4B;

}

/*if z is below base, calculate z length as such*/
else {

	theta2 = theta2B - theta2A;
	theta3 = 180 - theta3A;
	theta4 = theta4A - theta4B;

};

/*calculate theta5 later.  For now make 0*/
theta5 = 0.0;


/*with arm angles computed, we move the robot */

/*if angles are within the range of the robot arm, move as such*/

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

/*end of if y>=0 loop */
};


};

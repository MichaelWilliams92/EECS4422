/*Andrew Lau 212905253, Michael Williams 211087798*/

function robot_move(x, y, &optional gripper &init "default")
	"The function moves the robot arm to a x, y point on the world coordinate system. x and y are in centimeters. \n\
The arm will not move if the point is outside of the robot's reach. The optional parameter controls if the gripper\n\
is to be opened or close one the arm reaches the point\n\""
{

z = -5.0;
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


	rob_move_abs(theta1, theta2, theta3, theta4, theta5);
	sleep(3);
	if(gripper == "close"){
		servo_close(50);
	};
	if(gripper == "open"){
		servo_open(50);
	};

};

gaus = 0.9;
threshold = 30.0;
pixels_points = mk_fvec(1..2);
robot_points = mk_fvec(1..2);


function take_pic()

{
    con = fc2GetContext();
    con->camindex=0;
    fc2StartGrab(con);
    img=NIL;
    gshow(img=fc2GrabImgBW(con,img));
    con = NIL;
    GC();

};

function take_first_pic(){
	/*rob_ready();*/
	take_pic();
	img1 = img;
	img1 = to_fimg(img1) (*) mk_gauss_tmpl(gaus);
	result_img = img;
};


function my_abs(M)
{
    for (i=M->vmin; i<=M->vmax; i++)
    {
      for (j=M->hmin; j<M->hmax; j++)
        {
            if(M[i,j] < 0)
			{
				M[i,j] = -M[i,j];
			};
        };
    };
	M;
};

function pix_average(avg){
	sumX = 0;
	sumY = 0;
	
	for (i = avg->hmin + 1; i <= avg->hmax; i++){
		sumX += avg[1, i];
		y_sum += avg[2, i];
		
	};
	avgX = sumX/(avg->hmax -1);
	avgY = y_sum/(avg->hmax -1);
	pt = mk_fvec(1..2, [avgX, avgY]);

	for (i = avgX - 10; i <= avgX + 10; i++){
		for (j = avgY - 10; j <= avgY + 10; j++){

			if(i == avgX-10 || i == avgX || i == avgX+10){
	
				result_img[i,j] = 0;
				mask[i,j] = 0;
			};

			if(j == avgY-10 || j == avgY || j == avgY+10){
				result_img[i,j] = 0;
				mask[i,j] = 0;
			};
		}; 
	};

	pixels_points = pixels_points <-> pt;
};




function hand_eye_init(x1,y1,x2,y2){
	
	robot_move(x1,y1, "close");
	sleep(3);
	robot_move(x2,y2, "open");
	sleep(2);
	rob_ready();
	
	tempt = mk_fvec (1..2, [x2,y2]);
	
	robot_points = robot_points <-> tempt;
	
	rob_ready();
	sleep(3);
	
	take_pic();
	img2 = img;
	img2 = to_fimg(img2) (*) mk_gauss_tmpl(gaus);
	
	new_img = my_abs(img1 - img2);
	
	printf("this is a test");
	
	pix_avg = mk_fvec(1..2);
	
	get_mask(new_img);		

	pix_average(pix_avg);

};

function get_mask(temp_img){
	
	mask = mk_fimg(temp_img->vmax, temp_img->hmax);
		
	for (i=mask->vmin+1; i<=mask->vmax+1; i++)
    {
      	for (j=mask->hmin+1; j<=mask->hmax+1; j++)
       	{
       
			if (temp_img[i-1,j-1] > threshold)
			{
				pix_point = mk_fvec(1..2, [i-1, j-1]);
				pix_avg = pix_avg <-> pix_point;
				mask[i-1,j-1] = 255;
			};
       		};
	};
	

};

function hand_eye(x, y){
	
	
	
	robot_move(robot_points[1, robot_points->hmax], robot_points[2, robot_points->hmax], "close");
	sleep(3);
	
	robot_move(x, y, "open");
	
	sleep(3);
	
	rob_pt = mk_fvec(1..2, [x, y]); 
	robot_points = robot_points <-> rob_pt;
	
	rob_ready();
	sleep(5);
	
		
	take_pic();
	img2 = img;
	img2 = to_fimg(img2) (*) mk_gauss_tmpl(gaus);
	printf("Picture Taken");	

	new_img = my_abs(img1 - img2);
	
	pix_avg = mk_fvec(1..2);
	
	get_mask(new_img);
	
	pix_average(pix_avg);


};


/* EECS 4422 */
/* Assignment 1 */
/* Michael Williams, mw1992, 211087798 */
/*Andrew Lau, pellost ,212905253 */

function testGaborFilters(k, theta)
"this function tests the gabor filters at a given wavenumber(k) and at various angles(theta).  Initital angle is 0.  Each new image taken rotates the filters by the theta value given.  For ex) if theta = 30 degrees, the first image will have the filters applied at an angle of 0 degrees, the next at an angle of 30, etc\n"
{
   /* declare variables */
    local deviation, angle;
   
    angle=0.0;
    deviation=1/k; 

    img = NIL;

/*set up camera */

cam=LT_C920("/dev/video0");

 v4l2_streamon(cam);

/*take image from camera */

/*this is where the camrea stuff used to be */

for(Tk_Button_Set();!Tk_Button_Pressed(); gshow(img=v4l2_grab(cam),:tk_img="ltech",:update_now=t));
v4l2_streamoff(cam);

/*change to greyscale */

 cam=NIL;GC();

 N=60;

 imgg = (img->r+img->g+img->b);
 imgg /= 3;


/*produce all images at different angles for gabor filters*/
while (angle <= 2*PI){
   
    /* compute the cos and sin gabors */

   cgabor = mk_cgabor_tmpl2(deviation,:k=k,:theta=angle); 
    sgabor = mk_sgabor_tmpl2(deviation,:k=k,:theta=angle); 

 /*get the convolution of the image on with individual gabors */

         c_image = imgg(*)cgabor;
        s_image = imgg(*)sgabor;

 /* produce the final image by squaring the images and adding them together.  Then display it */

        final_image = (c_image * c_image) + (s_image * s_image);
        gshow(final_image,:rescale=t);

    /*increase angle of rotation of the filter for the next image */

        angle = angle + theta;

};




};

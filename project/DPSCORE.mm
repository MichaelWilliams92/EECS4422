fak = make_array(1023,nil);
fak2 = make_array(1023,nil);
fak3 = make_array(1023,nil);

list = mk_fvec(2);
x = mk_fmat(2,1,[[1], [1]]);

current = 0;
current2 = 0;
current3 = 0;

final = mk_fimg(512,512);

/*create image and white block in it */
img = mk_fimg(512,512);

	for(i = 1; i < 55; i++){
		for(j=1; j< 55;j++){
			img[i,j] = 255;
		};
	};

gshow(img);

/*next, create the point */
    a=mk_fvec(2);
    a[1] = 1;
    a[2] = 5;
 


function push(pt){

	if(current == 1023){
		printf("current is full\n");
		if(current2 == 1023){
			printf("current2 is full\n");
			current3 = current3 + 1;
	
			fak3[current3] = pt;

		}else{

			current2 = current2 + 1;
	
			fak2[current2] = pt;

		};
		

	}else{

		current = current + 1;
	
		fak[current] = pt;

	};
	 
	


};

function pop(){
	

	if(current3 == 0){
		if(current2 == 0){

				return = fak[current];
				current = current - 1;

		}else{

			return = fak2[current2];
			current2 = current2 - 1;

		};
		
	}else{

		return = fak3[current3];
		current3 = current3 - 1;

	};

	return;
};


function adjacentEdges(pt){
		
		if(to_integer(pt[1]) >= 1 && imgtemp[to_integer(pt[1])-1,to_integer(pt[2])] > 0){
			temppt = mk_fvec(2,[to_integer(pt[1])-1,to_integer(pt[2])]);
			push(temppt);
		};
	
		if(to_integer(pt[1]) <= img->vmax && imgtemp[to_integer(pt[1])+1,to_integer(pt[2])] > 0){
			temppt = mk_fvec(2,[to_integer(pt[1])+1,to_integer(pt[2])]);
			push(temppt);
		};

		if(to_integer(pt[2]) >= 1 && imgtemp[to_integer(pt[1]),to_integer(pt[2])-1] > 0){
			temppt = mk_fvec(2,[to_integer(pt[1]),to_integer(pt[2])-1]);
			push(temppt);
		};

		if(to_integer(pt[2]) <= img->hmax && imgtemp[to_integer(pt[1]),to_integer(pt[2])+1] > 0){
			temppt = mk_fvec(2,[to_integer(pt[1]),to_integer(pt[2])+1]);
			push(temppt);
		};

	


};


function DPS(imgtemp,pt){

	push(pt);

	while(current > 0){
		pt = pop();
		
		if(imgtemp[to_integer(pt[1]),to_integer(pt[2])] > 0){
		
			imgtemp[to_integer(to_integer(pt[1])),to_integer(pt[2])] = 0;
			
			list = list <->	pt; 		
			
			adjacentEdges(pt);
		}; 
	
	
	};

	list;
};




import math
import random

import cv2
import numpy as np

# initialize the list of reference points. This list will be populated by the points picked by the user
refPt = set([])


def ransac_circle(data):

    best_circle = []                   # This variable holds a list of circle parameters 

    remainder = set(data)
    while len(remainder) >= 3:
        new_sample = set([])        # The set of points that fit the best fit circle
        best = None
        best_count = 0
        for i in range(0, 200):
            # Pick three random points from data set
            sample = random.sample(remainder, 3)
            set_sample = set(sample)
            # Find best fit for the randomly picked points
            centerX, centerY, radius = fit_circle(sample)
            # Check which points outside of the sample set fit into the circle model
            also_inliers = find_nearest_points(remainder - set(sample), centerX, centerY, radius)

            # Threshold a circle to only be valid if there are 6 more points that fit it
            if len(also_inliers) >= 6:
                inliers = set_sample | also_inliers
                this_count = find_nearest_points(inliers, centerX, centerY, radius)

                # Keep track of only the best
                if len(this_count) > best_count:
                    best = [int(centerX), int(centerY), int(radius)]
                    best_count = len(this_count)
                    new_sample = this_count
        if len(new_sample) == 0:
            remainder = set([])
        else:
            # Decrement the size of left over
            remainder = remainder - new_sample
            best_circle.append(best)

    return best_circle



def find_nearest_points(data, centerX, centerY, radius):

    points_near = set([])
    for point in data:
        distance_from_center = math.sqrt((point[0] - centerX) ** 2 + (point[1] - centerY) ** 2)
        if distance_from_center <= radius**2:
            distance = abs(radius - distance_from_center)
        else:
            distance = abs(distance_from_center - radius)
        if distance <= 5:
            points_near.add(point)

    return points_near


def fit_circle(data):

    p = data[0]
    q = data[1]
    r = data[2]

    matrix = np.array([[p[0], p[1], 1], [q[0], q[1], 1], [r[0], r[1], 1]])
    answer = np.array([-(p[0]**2 + p[1]**2), -(q[0]**2 + q[1]**2), -(r[0]**2 + r[1]**2)])

    parameters = np.linalg.solve(matrix, answer)

    centerX = float(parameters[0])/2
    centerY = float(parameters[1])/2
    radius = math.sqrt(-parameters[2] + centerX**2 + centerY**2)
    return -centerX, -centerY, radius

def main():

    def click_point(event, x, y, flags, param):
        # grab references to the global variables
        global refPt

        # if the left mouse button was clicked, record the starting (x, y) coordinates
        if event == cv2.EVENT_LBUTTONDOWN:
            refPt.add((x, y))
            print("Added point {}, {} to the data set.".format(x, y))
            # draw a circle around the region of interest
            cv2.circle(image, (x, y), 3, (0, 0, 255), -1)
            cv2.imshow("image", image)

    image = cv2.imread("../4422Ass2/images/three_circles.png")
    #image = np.zeros((1000,1000,3), np.uint8)
    cv2.namedWindow("image")
    cv2.setMouseCallback("image", click_point)
    cv2.imshow("image", image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    if len(refPt) > 0:
        clone = image.copy()
        best_circle = ransac_circle(refPt)
        cv2.namedWindow("image")
        for fit in best_circle:
            cv2.circle(clone, (fit[0], fit[1]), fit[2], (0, 0, 255), 2)
        cv2.imshow("image", clone)
        cv2.waitKey(0)

    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()


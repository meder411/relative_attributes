README: relative_attributes associated files

FOLDER: 'data/'
'attributes_full.dat' - table of unseparated attribute data
'attributes_key.dat' - column labels of attribute data
'attributes_test.dat' - table of test images' attributes
'attributes_train.dat' - table of training images' attributes
'binary.dat' - ground truth binary from Table 1 in the paper
'binary_assign_test.dat' - ground truth binary assigned to each image in test images
'binary_assign_train.dat' - ground truth binary assigned to each image in training images
'features_test.dat' - features of the test images (1 per row)
'features_train.dat' - features of the training images (1 per row)
'people_key.dat' - row labels for each person in dataset
'ranking.dat' - ground truth ranking from Table 1 in the paper
'test_file_key.dat' - image names for each row of test image data
'train_file_key.dat' - image names for each row of training image data

FOLDER: 'faces/'
'test/' - folder containing 392 images of 8 celebrities (49 each) downloaded using the PubFig dataset
'train/' - folder containing 168 images of 8 celebrities (21 each) downloaded using the PubFig dataset

OTHER FILES:
'LMgist.m' - GIST descriptor code from Torralba et al.
'dev_people.txt' - list of names of people in PubFig developer dataset
'dev_urls.txt' - list of URLs for images in PubFig developer dataset
'extractFeatures.m' - function that goes through a directory of image files and returns the 557 dim concatenation of the GIST descriptor and Lab historgram
'getAttributes.m' - function that grabs the PubFig attributes associated with each image in the PubFig dataset
'getFaces.m' - function that automatically downloads images from the PubFig dataset and crops all to just the face rectangle, returning image index of successfully downloaded images
'getGist.m' - calculates bulk GIST descriptors (taken from http://people.csail.mit.edu/torralba/code/spatialenvelope/ and modifed slightly)
'getLabHist.m' - calculates Lab histogram of an image
'imresizecrop.m' - used as part of GIST code
'pubfig_attributes.txt' - list of attributes for each image in the PubFig developer dataset
'rankNewImage.m' - function that calculates ranking score of a new test image using the learning ranking function
'ranksvm.m' - rankSVM training code (taken from http://olivier.chapelle.cc/primal/primal_svm.m)
'readData.m' - hack-y function to read data files associated with my tests
'reconcileAttributes.m' - function to map attributes data extracted from the main list with the actual images saved from PubFig
'relativeAttributes.m' - MAIN FUNCTION: performs SVM classifications
'separateData.m' - script that separates attribute data into training and testing data
'showGist.m' - display option associate with GIST code
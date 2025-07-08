def binary_search(arr,item):
    low = 0
    high = len(arr)-1
    while low <= high:
        mid = (low + high) // 2
        guess = arr[mid]    # guess the midpoint (the median value) of the array.
        if guess == item:   # if the guess equals the item,
            return mid      # return the midpoint. End of loop.
        elif guess > item:  # if the guess (the value denoted by arr[mid]) is higher than the item,
            high = mid - 1  # the highest guess index number becomes 1 less than the mid, as the mid index was the last guess.
        else:               # the only logical alternative to the above two possibilities is that the guess was too low,
            low = mid + 1   # therefore, the lowest guess index becomes 1 higher than the mid. 
    return None

def find_smallest(arr):                 # used for selection sort below
    smallest = arr[0]                   # smallest is index 0 to start with
    smallest_index = 0                  # so is the return variable
    for i in range(1,len(arr)):         # loop across whole array
        if arr[i] < smallest:           # if the current index's value is smaller than smallest
            smallest = arr[i]           # make current index's value the smallest
            smallest_index = i          # do the same for the return variable
    return smallest_index

def selection_sort(arr):
    newArr = []
    copiedArr = list(arr)
    for i in range(len(copiedArr)):
        smallest = find_smallest(copiedArr)             # find the smallest value in the copied array list
        newArr.append(copiedArr.pop(smallest))          # append the smallest term to new array. Done using pop method 
    return newArr                                       # which removes & returns value at specified index
    
def quicksort(arr):                                     # time complexity: average is n log n, worst is n^2
    if len(arr) < 2:
        return arr
    else:
        pivot = arr[0]                                  # list comprehension - the following line says: less = [[expression] for [iterable] if [condition]]
        less = [i for i in arr[1:] if i <= pivot]       # sub-array of all the elements less than the pivot
        greater = [i for i in arr[1:] if i > pivot]     # sub-array of all the elements greater than the pivot
        return quicksort(less) + [pivot] + quicksort(greater)
    
def hash_table_tutorial(name):
    prices =  {}
    prices["egg"] = 0.24
    prices["salmon"] = 2.5
    prices["kidney"] = 1.50
    prices["steak"] = 4.49


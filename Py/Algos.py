def binary_search(arr,item):
    low = 0
    high = len(arr)-1
    while low <= high:
        mid = (low + high) // 2
        guess = arr[mid]
        if guess == item:   # if the guess equals the item,
            return mid      # return the midpoint - ie the middle index of the array. End of loop.
        elif guess > item:  # if the guess (the value denoted by arr[mid]) is higher than the item,
            high = mid - 1  # the highest guess index number becomes 1 less than the mid, as the mid index was the last guess.
        else:               # the only logical alternative to the above two possibilities is that the guess was too low,
            low = mid + 1   # therefore, the lowest guess index becomes 1 higher than the mid. 
    return None

def find_smallest(arr):
    smallest = arr[0]                   # smallest is index 0 to start with
    smallest_index = 0                  # so is the return variable
    for i in range(1,len(arr)):         # loop across whole array
        if arr[i] < smallest:           # if the current index's value is smaller than smallest
            smallest = arr[i]           # make that value the smallest
            smallest_index = i          # do the same for the return variable
    return smallest_index

def selection_sort(arr):
    newArr = []
    copiedArr = list(arr)
    for i in range(len(copiedArr)):
        smallest = find_smallest(copiedArr)     # find the smallest value in the copied array list
        newArr.append(copiedArr.pop(smallest))  # append the smallest term to new array. Done using pop method 
    return newArr                               # which removes & returns value at specified index
    
    
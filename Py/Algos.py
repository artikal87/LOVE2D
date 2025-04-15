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
            low = mid + 1   # therefore, the lowest guess index becomes 1 higher than the mid. Space
    return None

QuickSort <- function(num_vec) {
  # Sorts a num_vecor of numbers
  #
  # Args:
  #   @num_vec: num_vecor containing numbers
  #
  # Returns: ordered num_vecor of numbers

  # Stop if num_vecor has length of 1
  if (length(num_vec) <= 1) {
    return(num_vec)
  }
  # Pick an element from the num_vecor
  element <- num_vec[1]
  partition <- num_vec[-1]
  # Reorder num_vec so that integers less than element come before, and all integers greater come
  # after
  v1 <- partition[partition < element]
  v2 <- partition[partition >= element]
  # Recursively apply steps to smaller num_vectors.
  v1 <- QuickSort(v1)
  v2 <- QuickSort(v2)
  return(c(v1, element, v2))
}

QuickSort(c(89, 4, 5, 7, 1, 2, 9))

MergeSort <- function(num_vec) {
  MergeCall <- function(left, right) {
    # Recursive function to compare and append values in order
    # Create a list to hold the results
    result <- c()
    # This is our stop condition for MergeCall
    # While left and right contain a value, compare them
    while(length(left) > 0 && length(right) > 0) {
      # If left is less than or equal to right, add it to the result list
      if (left[1] <= right[1]) {
        result <- c(result, left[1])
        # Remove the value from the list
        left <- left[-1]
      } else {
        # When right is less than or equal to left, add it to the result
        result <- c(result, right[1])
        # Remove the appended integer from the list
        right <- right[-1]
      }
    }
    # Keep appending the values to the result while left and right exist
    if (length(left) > 0) {
      result <- c(result, left)
    }
    if (length(right) > 0) {
      result <- c(result, right)
    }
    return(result)
  }
  # Below is our stop condition for the MergeSort function
  # When the length of the vector is 1, just return the integer
  len <- length(num_vec)
  if (len <= 1) {
    num_vec
  } else {
    # Otherwise keep dividing the vector into two halves.
    middle <- length(num_vec) / 2
    # Add every integer from 1 to the middle to the left
    left <- num_vec[1:floor(middle)]
    right <- num_vec[floor(middle + 1):len]
    # Recursively call MergeSort() on the left and right halves.
    left <- MergeSort(left)
    right <- MergeSort(right)
    # Order and combine the results.
    if (left[length(left)] <= right[1]) {
      c(left, right)
    } else {
      MergeCall(left, right)
    }
  }
}

MergeSort(c(89, 4, 5, 7, 1, 2, 9))

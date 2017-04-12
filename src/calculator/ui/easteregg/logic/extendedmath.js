.pragma library

/**
  Return sign of number as positive or negative 1, if number is zero then it returns 0
  @param number Number which sign will be returned
  @return Return -1 or 1 in case if number is not zero else returns 0
  */
function sgn(number) {
    if(number === 0)
        return 0
    return Math.abs(number) / number
}

/**
  Checks whether is in interval
  @param number Number which will be tested
  @param start Bottom border of interval
  @param end Top border of interval
  @return True if number is in interval else returns false
  */
function numberInInterval(number, start, end) {
    if(number >= start && number <= end)
        return true
    return false
}

/**
  Checks whether two intervals intersects
  @param start1 Bottom border of first interval
  @param end1 Top border of first interval
  @param start2 Bottom border of second interval
  @param end2 Top border of second interval
  @return True if intervals intersects else returns false
  */
function intervalHasIntersection(start1, end1, start2, end2) {
    if(numberInInterval(start1, start2, end2) || numberInInterval(end1, start2, end2))
        return true
    return false
}

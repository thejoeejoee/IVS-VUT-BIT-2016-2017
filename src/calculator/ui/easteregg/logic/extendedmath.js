.pragma library

function numberInInterval(number, start, end) {
    if(number >= start && number <= end)
        return true
    return false
}

function intervalHasIntersection(start1, end1, start2, end2) {
    if(numberInInterval(start1, start2, end2) || numberInInterval(end1, start2, end2))
        return true
    return false
}

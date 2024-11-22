// Problem 1:
// Over how many years was the unemployment data collected?

// Single Line: db.unemployment.aggregate([ {$group: { _id: '$Year' }}, {$count: 'numOfYears'} ]);

db.unemployment.aggregate([      // Uses an aggregate function to make multiple stages
    {
        $group: {                // Creates a group stage in the aggregate to group data by a specific field
            _id: '$Year'         // Groups on the year
        } 
    }, 
    {
        $count: 'numOfYears'     // Creates a count stage in the aggregate to count the number of years from the previous stage's output
    } 
]);


// Problem 2:
// How many states were reported on in this dataset?

// Single line: db.unemployment.aggregate([ {$group: { _id: '$State' }}, {$count: 'numOfStates'} ]);

db.unemployment.aggregate([       // Uses an aggregate function to make multiple stages
    {
        $group: {                 // Creates a group stage in the aggregate to group data by a specific field
            _id: '$State'         // Groups on the state's name
        } 
    }, 
    { 
        $count: 'numOfStates'     // Creates a count stage in the aggregate to count the number of years from the previous stage's output
    } 
]);


// Problem 3:
// What does this query compute?
// db.unemployment.find({Rate : {$lt: 1.0}}).count()

/*
Answer: This query computes the number of documents that have an unemployment rate of less than 1.0% over the entire collection period.
*/


// Problem 4:
// Find all counties with unemployment rate higher than 10%.
// Assumptions: We can assume that the question is asking monthly and NOT an average all time OR per year.
//              We can assume that the question is asking for the output to be a list of counties (including relevant data) and NOT the size of the list.

// Single line: db.unemployment.aggregate([ {$project: { _id: 0 }}, {$match: { Rate: { $gt: 10.0 } }} ]);

db.unemployment.aggregate([       // Uses an aggregate function to make multiple stages
    {
        $project: {               // Creates a project stage in the aggregate to project onto which fields should be viewed
            _id: 0                // Hides the _id field from the output
        }
    }, 
    {
        $match: {                 // Creates a match stage in the aggregate to filter data from the previous stage's output
            Rate: { 
                $gt: 10.0         // Finds all documents where the rate is greater than 10.0%
            }
        }
    }
]);


// Problem 5:
// Calculate the average unemployment rate across all states.
// Assumptions: We can assume that the question is asking for each state (individually) over the entire collection period.

// Single line: db.unemployment.aggregate([ {$group: { _id: '$State', Rate: { $avg: '$Rate' } }}, {$sort: { _id: 1 }} ]);

db.unemployment.aggregate([       // Uses an aggregate function to make multiple stages
    {
        $group: {                 // Creates a group stage in the aggregate to group data by a specific field
            _id: '$State',        // Groups on the state's name
            Rate: {
                $avg: '$Rate'     // Calculates the state's average rate over the entire collection period
            }
        }
    },
    {
        $sort: {                  // Creates a sort stage in the aggregate to organize the data from the previous stage's output
            _id: 1                // Orders by the state's names alphabetically (ascending)
        }
    }
]);


// Problem 6:
// Find all counties with an unemployment rate between 5% and 8%.
// Assumptions: We can assume that the question is asking for the rate to be [5.0, 8.0] (inclusive).
//              We can assume that the question is asking monthly per each state's county (with a rate of 5.0-8.0%) and NOT an average all time OR per year.
//              We can assume that the question is asking for the output to be a list of counties (including relevant data) and NOT the size of the list.

// Single line: db.unemployment.aggregate([ {$project: { _id: 0 }}, {$match: { Rate: { $gte: 5.0, $lte: 8.0 } }} ]);

db.unemployment.aggregate([     // Uses an aggregate function to make multiple stages
    {
        $project: {             // Creates a project stage in the aggregate to project onto which fields should be viewed
            _id: 0              // Hides the _id field from the output
        }
    }, 
    {
        $match: {               // Creates a match stage in the aggregate to filter data from the previous stage's output
            Rate: { 
                $gte: 5.0,      // Finds all documents where the rate >= 5.0% AND
                $lte: 8.0       // where the rate <= 8.0%
            }
        }
    }
]);


// Problem 7:
// Find the state with the highest unemployment rate. Hint: Use { $limit: 1 }
// Assumptions: We can assume that the question is asking for the state with the highest average unemployment rate over the entire collection period.

// Single line: db.unemployment.aggregate([ {$group: { _id: '$State', Rate: { $avg: '$Rate' } }}, {$sort: { Rate: -1 }}, {$limit: 1}, {$project: { State: 1 }} ]);

db.unemployment.aggregate([       // Uses an aggregate function to make multiple stages
    {
        $group: {                 // Creates a group stage in the aggregate to group data by a specific field
            _id: '$State',        // Groups on the state's name
            Rate: { 
                $avg: '$Rate'     // Calculates the state's average rate over the entire collection period
            }
        }
    },
    {
        $sort: {                  // Creates a sort stage in the aggregate to organize the data from the previous stage's output
            Rate: -1              // Orders by descending rate percentage
        }
    },
    {
        $limit: 1                 // Creates a limit stage in the aggregate to limit the data from the previous stage's output to 1 (the highest rate)
    },
    {
        $project: {               // Creates a project stage in the aggregate to project onto which fields should be viewed from the previous stage's output
            State: 1              // Shows only the State field in the output
        }
    }
]);


// Problem 8:
// Count how many counties have an unemployment rate above 5%.
// Assumptions: We can assume that the question is asking for each state's county's average rate over the entire collection period.
//              We can assume that the question is asking for the rate to be (5.0, infinity) (exclusive).

// Single line: db.unemployment.aggregate([ {$group: { _id: { State: '$State', County: '$County' }, Rate: { $avg: '$Rate' } }}, {$match: { Rate: { $gt: 5.0 } }}, {$count: 'numOfCounties'} ]);

db.unemployment.aggregate([           // Uses an aggregate function to make multiple stages
    {
        $group: {                     // Creates a group stage in the aggregate to group data by a specific field
            _id: {
                State: '$State',      // Groups on the state's name
                County: '$County'     // Groups on the state's county name
            },
            Rate: {
                $avg: '$Rate'         // Calculates the state's county's average rate over the entire collection period
            }
        }
    },
    {
        $match: {                     // Creates a match stage in the aggregate to filter data from the previous stage's output
            Rate: {
                $gt: 5.0              // Finds all documents where the rate is greater than 5.0%
            }
        } 
    },
    {
        $count: 'numOfCounties'       // Creates a count stage in the aggregate to count the number of counties from the previous stage's output
    }
]);


// Problem 9:
// Calculate the average unemployment rate per state by year.

// Single line: db.unemployment.aggregate([ {$group: { _id: { State: '$State', Year: '$Year' }, Rate: { $avg: '$Rate' } }} ]);

db.unemployment.aggregate([          // Uses an aggregate function to make multiple stages
    {
        $group: {                    // Creates a group stage in the aggregate to group data by a specific field
            _id: {
                State: '$State',     // Groups on the state's name
                Year: '$Year'        // Groups on the year
            },
            Rate: { 
                $avg: '$Rate'        // Calculates the state's average rate per year
            }
        }
    }
]);


// (Extra Credit 1)
// For each state, calculate the total unemployment rate across all counties (sum of all county rates).
// Assumptions: We can assume that the question is inferring that the total rate for the states should be summed up per year.

// Single line: db.unemployment.aggregate([ {$group: { _id: { State: '$State', County: '$County', Year: '$Year' }, AvgCountyRate: { $avg: '$Rate' } }}, {$group: { _id: { State: '$_id.State', Year: '$_id.Year' }, count: { $sum: '$AvgCountyRate' } }} ]);

db.unemployment.aggregate([                // Uses an aggregate function to make multiple stages
    {
        $group: {                          // Creates a group stage in the aggregate to group data by a specific field
            _id: {
                State: '$State',           // Groups on the state's name
                County: '$County',         // Groups on the state's county's name
                Year: '$Year'              // Groups on the year
            },
            AvgCountyRate: {
                $avg: '$Rate'              // Calculates the state's county's average rate in a year
            }
        }
    },
    {
        $group: {                          // Creates another group stage in the aggregate to group data by fields from the previous stage's output
            _id: {
                State: '$_id.State',       // Groups on the state's name contained in the _id object from the previous output
                Year: '$_id.Year'          // Groups on the year contained in the _id object from the previous output
            },
            count: {
                $sum: '$AvgCountyRate'     // Sums all the averaged county's rates in a year
            }
        }
    }
]);


// (Extra Credit 2)
// The same as Query 10 but for states with data from 2015 onward.

// Single line: db.unemployment.aggregate([ {$match: { Year: { $gte: 2015 } }}, {$group: { _id: { State: '$State', County: '$County', Year: '$Year' }, AvgCountyRate: { $avg: '$Rate' } }}, {$group: { _id: { State: '$_id.State', Year: '$_id.Year' }, count: { $sum: '$AvgCountyRate' } }} ]);

db.unemployment.aggregate([                // Uses an aggregate function to make multiple stages
    {
        $match: {                          // Creates a match stage in the aggregate to filter data
            Year: {                        
                $gte: 2015                 // Finds all documents with the year >= 2015
            }
        } 
    },
    {
        $group: {                          // Creates a group stage in the aggregate to group data by fields from the previous stage's output
            _id: {
                State: '$State',           // Groups on the state's name
                County: '$County',         // Groups on the state's county's name
                Year: '$Year'              // Groups on the year
            },
            AvgCountyRate: {
                $avg: '$Rate'              // Calculates the state's county's average rate in a year
            }
        }
    },
    {
        $group: {                          // Creates another group stage in the aggregate to group data by fields from the previous stage's output
            _id: {
                State: '$_id.State',       // Groups on the state's name contained in the _id object from the previous output
                Year: '$_id.Year'          // Groups on the year contained in the _id object from the previous output
            },
            count: {
                $sum: '$AvgCountyRate'     // Sums all the averaged county's rates in a year
            }
        }
    }
]);

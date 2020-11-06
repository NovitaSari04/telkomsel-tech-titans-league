-- Create table Candidates and Results in local database so we can check our query 
create table Candidates(
	id INT,
	gender VARCHAR(100),
	age INT,
	party VARCHAR(100)
)

create table Results(
	constituency_id INT,
	candidate_id INT,
	votes INT
)

-- Insert value into table Candidates and Results
insert into Candidates (id, gender, age, party)
	VALUES
		(1,'M',55,'Democratic'),
		(2,'M',51,'Democratic'),
		(3,'F',62,'Democratic'),
		(4,'M',60,'Republic'),
		(5,'F',61,'Republic'),
		(6,'F',58,'Republic')

insert into Results (constituency_id, candidate_id, votes)
	VALUES
		(1,1,847529),
		(1,4,283409),
		(2,2,293841),
		(2,5,394385),
		(3,3,429084),
		(3,6,303890)
		
/*
the expected column output of the query is --> party | seats_won
before creating query, we will plan the query
1. using window function create rank of the candidate, partition by constituency and order by number of votes desc from results table
2. make step 1 as subquery, and join with table candidates on candidate_id
3. select party and count(*), filter only rank 1, group by party
*/

select party, 
	COUNT(*) as seats_won 
FROM
	(select candidate_id,
		RANK() over (partition by constituency_id order by votes DESC)
		from Results) as winner
join candidates
	on winner.candidate_id = Candidates.id
where rank = 1
group by party;
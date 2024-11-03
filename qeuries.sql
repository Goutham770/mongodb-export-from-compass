 --1.Find all the topics and tasks taught in the month of October.

db.topics.aggregate([
  {
    $lookup: {
      from: "tasks",
      localField: "topic_id",
      foreignField: "topic_id",
      as: "tasks"
    }
  },
  {
    $match: {
      $expr: {
        $eq: [{ $month: "$date_taught" }, 10]
      }
    }
  }
]);

--2.Find all the company drives which appeared between 15 Oct 2020 and 31 Oct 2020.

db.company_drives.find({
  date: { $gte: ISODate("2020-10-15"), $lte: ISODate("2020-10-31") }
});

--3.Find all the company drives and students who appeared for the placement.

db.attendance.aggregate([
  {
    $match: { status: "present" }
  },
  {
    $lookup: {
      from: "company_drives",
      localField: "date",
      foreignField: "date",
      as: "company_drive"
    }
  },
  {
    $lookup: {
      from: "users",
      localField: "user_id",
      foreignField: "user_id",
      as: "student"
    }
  }
]);

--4.Find the number of problems solved by the user in CodeKata.

db.codekata.find({}, { user_id: 1, problems_solved: 1 });


--5.Find all the mentors who have mentees count more than 15.

db.mentors.find({ mentees_count: { $gt: 15 } });


--6.Find the number of users who are absent and tasks not submitted between 15 Oct 2020 and 31 Oct 2020.

db.attendance.aggregate([
  {
    $match: {
      status: "absent",
      date: { $gte: ISODate("2020-10-15"), $lte: ISODate("2020-10-31") }
    }
  },
  {
    $lookup: {
      from: "tasks",
      localField: "user_id",
      foreignField: "user_id",
      as: "tasks"
    }
  },
  {
    $match: { "tasks.status": "not submitted" }
  },
  {
    $count: "absent_users_count"
  }
]);

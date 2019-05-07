<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.3.1/css/all.css"
	integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU"
	crossorigin="anonymous">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/annyang/2.6.0/annyang.min.js"></script>
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.8.10/themes/smoothness/jquery-ui.css"
	type="text/css">
<script type="text/javascript"
	src="//ajax.aspnetcdn.com/ajax/jquery.ui/1.8.10/jquery-ui.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<title>Student Home Page</title>
</head>
<body>

	<script>
		
	function enroll(cId) {
		$.ajax({
            type: "post",
            url: "/Idbms-Project/enrollToCourse?courseId="+cId,
            contentType: "application/json",                	
            success: function(msg){ 
            	location.reload(true);
            }
        });	
	}
	
	// Logout
	function logout(){
		$("#stuForm").attr("action", "/Idbms-Project/logout").submit();
	}
	
	</script>
<form id="stuForm" action="get">
	<nav class="navbar navbar-inverse">
	<div class="container-fluid">
		<div class="navbar-header">
			<a class="navbar-brand" href="#">Student Home Page</a>
		</div>
		<ul class="nav navbar-nav">
			<li class="active"><a href="#courses" data-toggle="pill">Courses</a></li>
			<li><a href="#enrolledcourses" data-toggle="pill">Your
					Enrolled Courses/ Grades</a></li>
		</ul>
		<ul class="nav navbar-nav navbar-right">
			<li><a href="javascript:logout();" data-toggle="pill"><span
					class="glyphicon glyphicon-log-out"></span> Logout</a></li>
		</ul>
	</div>
	</nav>
	</form>

	<div class="container">
		<div class="tab-content">
			<div id="courses" class="tab-pane fade in active">

				<div class="table-responsive">
					<table class="table">
					<thead>
								<tr>
									<th>Course ID</th>
									<th>Course Name</th>
									<th>Course Description</th>
									<th>Enrolled ?</th>
								</tr>
							</thead>
							<tbody>
						<!-- Show All Courses -->
						<c:forEach var="courseDetail" items="${allCoursesPresent}">							
								<tr>
									<td>${courseDetail.courseId}</td>
									<td>${courseDetail.courseName}</td>
									<td>${courseDetail.courseDescription}</td>
									<c:choose>
										<c:when test="${courseDetail.userId ne null
												and courseDetail.userId eq userId}">
											<td>You are Enrolled to this Course</td>
										</c:when>
										<c:otherwise>											
											<td><a
												href="javascript:enroll(${courseDetail.courseId})">Enroll</a></td>
										</c:otherwise>
									</c:choose>
								</tr>
							</tbody>
						</c:forEach>
					</table>
				</div>

			</div>

			<div id="enrolledcourses" class="tab-pane fade">
			
			<div class="table-responsive">
					<table class="table">
					<thead>
								<tr>
									<th>Course ID</th>
									<th>Course Name</th>
									<th>Course Description</th>
									<th>Grade</th>
								</tr>
							</thead>
							<tbody>
						<!-- Show All Courses -->
						<c:forEach var="stuGrade" items="${studentGrades}">							
								<tr>
									<td>${stuGrade.courseId}</td>
									<td>${stuGrade.courseName}</td>
									<td>${stuGrade.courseDescription}</td>
									<c:choose>
										<c:when test="${stuGrade.grade eq null}">
											<td>No Grades are present for this Course</td>
										</c:when>
										<c:otherwise>
											<td>${stuGrade.grade}</td>
										</c:otherwise>
									</c:choose>
								</tr>
							</tbody>
						</c:forEach>
					</table>
				</div>
			
			</div>

		</div>
</body>

</html>
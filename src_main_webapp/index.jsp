<!--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at
 
        http://www.apache.org/licenses/LICENSE-2.0
 
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
 -->
<%@include file="header.jsp"%>
<%@page pageEncoding="UTF-8"%>
<% /* Author: Andrew C. Oliver (acoliver2@users.sourceforge.net) */ %>
<center> 
	<form name="search" action="results.jsp" method="get">
		<p>
			<input placeholder="ลอง เกิดใหม่,เวทมนต์" name="query" size="44"/>&nbsp;Search Here
		</p>
		<p>
			<input name="maxresults" size="4" value="10"/>&nbsp;Results Per Page&nbsp;
			<input type="submit" value="Search"/>
		</p>
        </form>
</center>
<!-- 
<%@include file="footer.jsp"%>
 -->


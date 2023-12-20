<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.lang.Math"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%
	//치환 변수 선언합니다.
	pageContext.setAttribute("crcn", "\r\n"); //Space, Enter
	pageContext.setAttribute("br", "<br/>"); //br 태그
%>
<head>
<title>검색 도서 목록 페이지</title>
</head>
<body>
	<hgroup>
		<h1>오늘의 상품</h1>
		<h2></h2>
	</hgroup>
	<section id="new_book">
		<h3>신상품</h3>
		<div id="left_scroll">
			<a href='javascript:slide("left");'> <%-- <img src="${contextPath}/resources/image/left.gif"> --%>
			</a>
		</div>
		<div id="carousel_inner">
			<ul id="carousel_ul">
				<c:choose>
					<c:when test="${ empty goodsList  }">
						<li>
							<div id="book">
								<a><h1>제품이 없습니다.</h1></a>
							</div>
						</li>
					</c:when>
					<c:otherwise>
						<c:forEach var="item" items="${goodsList }">
							<li>
								<div id="book">
									<a
										href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">
										<img width="75" alt=""
										src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_image_fileName}">
									</a>
									<div class="title">
										<a
											href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">
											${item.goods_name} </a>
									</div>
									<div class="writer">
										<%-- ${item.goods_writer} | ${item.goods_publisher} --%>
									</div>
									<div class="price">
										<span> <fmt:formatNumber value="${item.goods_price}"
												type="number" var="goods_price" /> ${goods_price}원
										</span> <br>
										<fmt:formatNumber value="${item.goods_sell_price}"
											type="number" var="discounted_price" />
										${discounted_price}원 <br>
										<c:set var="discount_rate"
											value="${100 - (item.goods_sell_price / item.goods_price) * 100 }" />
										(${discount_rate.intValue()}%할인)
										</td>
									</div>
								</div>
							</li>
						</c:forEach>
						<li></li>
					</c:otherwise>
				</c:choose>

			</ul>
		</div>
		<div id="right_scroll">
			<a href='javascript:slide("right");'> <%-- <img  src="${contextPath}/resources/image/right.gif"> --%>
			</a>
		</div>
		<input id="hidden_auto_slide_seconds" type="hidden" value="0">

		<div class="clear"></div>
	</section>
	<div class="clear"></div>
	<div id="sorting">
		<ul>
			<li><a class="active" href="#">인기순</a></li>
			<li><a href="#">최신순</a></li>
			<li><a style="border: currentColor; border-image: none;"
				href="#">뭐씀</a></li>
		</ul>
	</div>
	<table id="list_view">
		<tbody>
			<c:forEach var="item" items="${goodsList }">
				<tr>
					<td class="goods_image"><a
						href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">
							<img width="75" alt=""
							src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_image_fileName}">
					</a></td>
					<td class="goods_description">
						<h2>
							<a
								href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">${item.goods_name }</a>
						</h2> <c:set var="goods_pub_date" value="" /> <c:set var="arr"
							value="" />
						<div class="writer_press"></div>
					</td>
					<td class="price"><span> <fmt:formatNumber
								value="${item.goods_price}" type="number" var="goods_price" />
							${goods_price}원
					</span> <br> <fmt:formatNumber value="${item.goods_sell_price}"
							type="number" var="discounted_price" /> <strong>${discounted_price}원 </strong><br>
						<c:set var="discount_rate"
							value="${100 - (item.goods_sell_price / item.goods_price) * 100 }" />
						(${discount_rate.intValue()}%할인)</td>
					<td><input type="checkbox" value=""></td>
					<td class="buy_btns">
						<UL>
							<li><a href="#">장바구니</a></li>
							<li><a href="#">구매하기</a></li>
							<li><a href="#">비교하기</a></li>
						</UL>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="clear"></div>
	<div id="page_wrap">
		<ul id="page_control">

			<!-- <li><a class="no_border" href="#">Prev</a></li> -->


			<c:set var="page_num" value="0" />
<%
	Object countObj = request.getAttribute("searchkeyword");
	int count1 = (countObj instanceof Integer) ? (Integer) countObj : 0;
	int roundedPageCount = (int) Math.ceil((double) count1 / 10);
	pageContext.setAttribute("roundedPageCount", roundedPageCount);
%>
			<c:forEach var="page" begin="1" end="${roundedPageCount }" step="1">
				
				<c:choose>
					<c:when test="${page==1 }">
						<li><a class="page_contrl_active" href="#">${page+page_num*10 }</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="#">${page+page_num*10 }</a></li>
					</c:otherwise>
				</c:choose>
		         
			</c:forEach>

			<!-- <li><a class="no_border" href="#">Next</a></li> -->
		</ul>
	</div>
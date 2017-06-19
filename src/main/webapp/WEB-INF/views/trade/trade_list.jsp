<%@ page language="java" import="java.util.*,org.lanqiao.pay.base.entity.*
,org.lanqiao.pay.base.util.*,org.lanqiao.pay.base.bean.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>企业用户显示</title>
	<link rel="stylesheet" type="text/css" href="${applicationScope.url }/resources/lanqiaoPayModel/css/global.css">
	<link rel="stylesheet" type="text/css" href="${applicationScope.url }/resources/lanqiaoPayModel/css/list.css">
	<link rel="stylesheet" type="text/css" href="${applicationScope.url }/resources/lanqiaoPayModel/css/laydate.css">
	<link rel="stylesheet" type="text/css" href="${applicationScope.url }/resources/lanqiaoPayModel/css/biz/trade.css">
	<script type="text/javascript" src="${applicationScope.url }/resources/lanqiaoPayModel/js/jquery.js"></script>
	<script type="text/javascript" src="${applicationScope.url }/resources/lanqiaoPayModel/js/global.js"></script>
	<script type="text/javascript" src="${applicationScope.url }/resources/lanqiaoPayModel/js/util.js"></script>
	<script type="text/javascript" src="${applicationScope.url }/resources/lanqiaoPayModel/js/list.js"></script>
	<script type="text/javascript" src="${applicationScope.url }/resources/lanqiaoPayModel/js/laydate.js"></script>
	<script type="text/javascript" src="${applicationScope.url }/resources/bootstrap/js/kkpager.min.js"></script>
	<link rel="stylesheet" type="text/css" href="${applicationScope.url }/resources/bootstrap/css/kkpager_blue.css" />
	<%  TradePage tradePage	= (TradePage)request.getAttribute("tradePage");
		Date getBegainTradeRange = tradePage.getBegainTradeRange();
		String getBegainTradeRangeStr = MyUtils.dateToString(getBegainTradeRange);
		Date getEndeTradeRange = tradePage.getEndeTradeRange();
		String getEndeTradeRangeStr = MyUtils.dateToString(getEndeTradeRange);
	%>
	<script type="text/javascript">
	$(function(){
		//选中交易类型中的所有直接子元素.当这些子元素任意一个被点击的时候就取消所有的class(即current),然后在为被点击的元素附上class
		$("[name=tradeTypeUl]").children().click(function(){
			$("[name=tradeTypeUl]").children().removeAttr("class");
			//alert(this);
			this.setAttribute("class", "current");
			var value = this.getAttribute("val")
			$("[name=tradeTypeIn]").val(value);
		});
		$("[name=tradeDateRangeType]").children().click(function(){
			$("[name=tradeDateRangeType]").children().removeAttr("class");
			this.setAttribute("class", "current");
			var value = this.getAttribute("val");
			$("[name=tradeDateRangeTypeIn]").val(value);
		});
		//当页码输入框没值的话,使确定按钮失效
		/* $("[id=kkpager_btn_go]").mouseover(function(){
				alert(1);
		}); */
		//点击提交表单的时候需要判断交易类型,根据交易类型去不同的控制器.
		$("[name=submitForm]").click(function(){
			var tradeType = $("[name=tradeTypeIn]").val();
			var tradeDateRangeType = $("[name=tradeDateRangeTypeIn]").val();
			var tradeNumber = $("[name=tradeNumber]").val().trim();
			var tradeName = $("[name=tradeName]").val().trim();
			var begainTradeRange = $("[name=begainTradeRange]").val();
			var endeTradeRange = $("[name=endeTradeRange]").val();
			var initiator	= 	$('#initiator option:selected') .val();//选中的值
			var tradeState = $("#tradeState option:selected") .val(); 
			var begainMoneyRange = $("[name=begainMoneyRange]").val().trim();
			var endMoneyRange = $("[name=endMoneyRange]").val().trim();
			
			//对条件的和法性进行判断
			if(tradeNumber!=''){
				var r = /^\+?[1-9][0-9]*$/;
				var flag=r.test(tradeNumber);
				if(flag == false){
					alert("交易号必须为正整数!");
					return false;
				}else if(parseInt(tradeNumber) == 0){
					alert("交易号必须为正整数!");
					return false;
				}else{//说明现在才是合法的交易号,所以给tradeNumber附上
					
				}
			}
			//对价格区间的值进行检验
			if(begainMoneyRange != ''){
				var r	=	/^[0-9]+([.][0-9]+)?$/;
				var b = r.test(begainMoneyRange);
				if(b){
					
				}else{
					alert("价格区间必须是非负的浮点数!");
					return false;					
				}
			}
			if(endMoneyRange != ''){
				var r	=	/^[0-9]+([.][0-9]+)?$/;
				var e = r.test(endMoneyRange);
				if(e){
				
				}else{
					alert("价格区间必须是非负的浮点数!");
					return false;		
				}
			}
			var condations = 'tradeType='+tradeType+'&tradeDateRangeType='+tradeDateRangeType
			+'&tradeNumber='+tradeNumber+'&tradeName='+tradeName+"&begainTradeRange="+begainTradeRange
			+"&endeTradeRange="+endeTradeRange+"&initiator="+initiator+"&tradeState="+tradeState
			+"&begainMoneyRange="+begainMoneyRange+"&endMoneyRange="+endMoneyRange;
			if(tradeType == 3){//需要去查询转账记录
				alert(condations);
				this.href='${applicationScope.url }/tradeController/listTradeTransfer?'+condations;
			}
			else{//充值和提现
				alert(condations);
				this.href='${applicationScope.url }/tradeController/listTrade?'+condations;
			}
		});
		
	});
	
	</script>
<c:if test="${requestScope.listPageType == 0}">
		<!-- 
			该页面正确分页查询操作应该是,如果条件变换的话,那么应该点击提交表单后,再去进行下面的页面变换.否则
			分页条件变化后直接点击切换页面的话,默认的会使用上一次分页的条件
		 -->
<script type="text/javascript">
//init
$(function(){
	var totalPage = "${tradePage.totalPage}";
	var totalRecords = "${tradePage.totalRecords}";
	var pageNo = ${tradePage.pageNo}
	//生成分页
	//有些参数是可选的，比如lang，若不传有默认值
	kkpager.generPageHtml({
		pno : pageNo,
		//总页码
		total : totalPage,
		//总数据条数
		totalRecords : totalRecords,
		//链接前部
		hrefFormer : '${applicationScope.url }/tradeController/listTrade',
		//链接尾部
		hrefLatter : '&tradeType=${tradePage.tradeType}&tradeDateRangeType=${tradePage.tradeDateRangeType}'
		+'&tradeNumber=${tradePage.tradeNumber}&tradeName=${tradePage.tradeName}'
		+'&begainTradeRange=<%=getBegainTradeRangeStr%>&endeTradeRange=<%=getEndeTradeRangeStr%>'
		+'&initiator=${tradePage.initiator}&tradeState=${tradePage.tradeState}'
		+'&begainMoneyRange=${tradePage.begainMoneyRange}&endMoneyRange=${tradePage.endMoneyRange}',
		getLink : function(n){
			return this.hrefFormer +"?pageNo="+n + this.hrefLatter; 
		}
	});
});
</script>
</c:if>

<c:if test="${requestScope.listPageType == 1}">
		
<script type="text/javascript">
//init
$(function(){
	var totalPage = "${tradePage.totalPage}";
	var totalRecords = "${tradePage.totalRecords}";
	var pageNo = ${tradePage.pageNo}
	//生成分页
	//有些参数是可选的，比如lang，若不传有默认值
	kkpager.generPageHtml({
		pno : pageNo,
		//总页码
		total : totalPage,
		//总数据条数
		totalRecords : totalRecords,
		//链接前部
		hrefFormer : '${applicationScope.url }/tradeController/listTradeTransfer',
		//链接尾部
		hrefLatter : '&tradeType=${tradePage.tradeType}&tradeDateRangeType=${tradePage.tradeDateRangeType}'
		+'&tradeNumber=${tradePage.tradeNumber}&tradeName=${tradePage.tradeName}'
		+'&begainTradeRange=<%=getBegainTradeRangeStr%>&endeTradeRange=<%=getEndeTradeRangeStr%>'
		+'&initiator=${tradePage.initiator}&tradeState=${tradePage.tradeState}'
		+'&begainMoneyRange=${tradePage.begainMoneyRange}&endMoneyRange=${tradePage.endMoneyRange}',
		getLink : function(n){
			return this.hrefFormer +"?pageNo="+n + this.hrefLatter; 
		}
	});
});
</script>
</c:if>
</head>

<body>
		
		<div id="page">
			<div class="main layout">
				<div class="glb-list-box">
					
					<div class="glb-list-bd">
						<div class="list-cond-box" >
							<div class="list-cond-hd clearfix">
								<ul class="cond-col-l list-cond-items" name="tradeTypeUl">
									<li class="${requestScope.tradePage.tradeType == 0? 'current':'' }" val="0">
										<a href="#">充值记录</a>
									</li>
									<li class="${requestScope.tradePage.tradeType == 4? 'current':'' }" val="4">
										<a href="#">提现记录</a>
									</li>
									<li class="${requestScope.tradePage.tradeType == 3? 'current':'' }" val="3">
										<a href="#">转账记录</a>
									</li>
								</ul>
								<input type="hidden" name="tradeTypeIn" value="${requestScope.tradePage.tradeType }"/>
								<ul class="cond-col-r list-cond-items" name="tradeDateRangeType">
									<li class="${requestScope.tradePage.tradeDateRangeType == 0? 'current':'' }" val="0">
										<a href="#">今天交易</a>
									</li>
									<li class="${requestScope.tradePage.tradeDateRangeType == 1? 'current':'' }" val="1">
										<a href="#">一周内交易</a>
									</li>
									<li class="${requestScope.tradePage.tradeDateRangeType == 2? 'current':'' }" val="2">
										<a href="#">一月内交易</a>
									</li>
									<li class="${requestScope.tradePage.tradeDateRangeType == 3? 'current':'' }" val="3">
										<a href="#">3个月内交易</a>
									</li>
									<li class="${requestScope.tradePage.tradeDateRangeType == 4? 'current':'' }" val="4">
										<a href="#">1年内交易</a>
									</li>
								</ul>
								<input type="hidden" name="tradeDateRangeTypeIn" value="${requestScope.tradePage.tradeDateRangeType }"/>
								<a id="moreCondBtn" class="more-cond-btn cond-tbs-down" href="javascript:;">
									更多条件
									<span class="iconfont icon-arrow-up"></span>
								</a>
							</div>
							<div id="listCondBd" class="list-cond-bd clearfix"><!-- 在不显示的时候为style="display: none;" -->
								<table class="list-cond-tbs">					<!-- style="display: block;" -->
									<tr>
										<th>交易号:</th>
										<td>
											<input type="text" class="ipt" name="tradeNumber"
											value="${requestScope.tradePage.tradeNumber}"/>
										</td>
										<th>交易名称:</th>
										<td>
											<input type="text" class="ipt" name="tradeName"
											value="${requestScope.tradePage.tradeName}"/>
										</td>
										<th>日期区间:</th>
										<td>
											<div class="list-cond-between">
											
												<input type="text" class="ipt ipt-date twin-item" onclick="laydate()" 
														name="begainTradeRange" 
														value="<%=getBegainTradeRangeStr %>"
														/>
												<span class="twin-ft">-</span>
												<input type="text" class="ipt ipt-date twin-item" onclick="laydate()" 
														name="endeTradeRange" 
														value="<%=getEndeTradeRangeStr %>"/>
											</div>
										</td>
									</tr>
									<tr>
										<th>发起方:</th>
										<td>
											<select class="sel" name="initiator" id="initiator">
												<option value="0" ${requestScope.tradePage.initiator==0?'selected':'' }>全部</option>
												<option value="1" ${requestScope.tradePage.initiator==1?'selected':'' }>个人</option>
												<option value="2" ${requestScope.tradePage.initiator==2?'selected':'' }>企业</option>
											</select>
										</td>
										<th>交易状态:</th>
										<td>
											<select class="sel" name="tradeState" id="tradeState">
												<option value="-1" ${requestScope.tradePage.tradeState==-1?'selected':'' }>全部</option>
												<option value="0"  ${requestScope.tradePage.tradeState==0?'selected':'' }>等待审核</option>
												<option value="1" ${requestScope.tradePage.tradeState==1?'selected':'' }>审核通过</option>
												<option value="2" ${requestScope.tradePage.tradeState==2?'selected':'' }>交易成功</option>
											</select>
										</td>
										<th>金额区间:</th>
										<td>
											<div class="list-cond-between">
												<input type="text" name="begainMoneyRange" class="ipt twin-item" 
													value="${requestScope.tradePage.begainMoneyRange}"/>
												<span class="twin-ft">-</span>
												<input type="text" name="endMoneyRange" class="ipt twin-item" 
													value="${requestScope.tradePage.endMoneyRange}"/>
											</div>
										</td>
									</tr>
								</table>
								<a href="#" class="cmn-btn cmn-btn-blue submit-cond-btn" name="submitForm">提交表单</a>
							</div>
						</div>
						<table class="list-main-tbs trade-list-tbs">
							<thead>
								<tr>
									<th>#</th>
									<th>创建时间</th>
									<th class="tac">名称</th>
									<th class="tac">发起方</th>
									<th class="tac">交易号</th>
									<th class="tac">金额</th>
									<th class="tac">状态</th>
									<th class="tac">操作</th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${requestScope.listPageType == 0}">
								
								<c:forEach items="${requestScope.recharge_withdrawals }" var="recharge_withdrawals" varStatus="vs">
								<tr>
									<td class=" tac">${vs.index+1 }</td>
									<c:set scope="page" var="time" value="${recharge_withdrawals.time }"></c:set>
					   				<%
					   					Date date = (Date)pageContext.getAttribute("time");
										String timeStr = MyUtils.dateAndTimeDateToStringNoSeconds(date);
					   				 %>
									<td class="td-col-date "><%=timeStr %></td>
									<td class="td-col-type tac">${recharge_withdrawals.transaction_name }</td>
									<td class="td-col-sponsor tac">
										<c:if test="${!empty recharge_withdrawals.user}">个人</c:if>
										<c:if test="${!empty recharge_withdrawals.enterprise}">企业</c:if>
									</td>
									<td class=" tac">${recharge_withdrawals.id}</td>
									<td class=" tac">${recharge_withdrawals.money}</td>
									<td class="td-col-status tac">
										<c:if test="${recharge_withdrawals.state == 0||recharge_withdrawals.state == 3}">等待审核</c:if>
										<c:if test="${recharge_withdrawals.state == 1||recharge_withdrawals.state == 4}">审核通过</c:if>
										<c:if test="${recharge_withdrawals.state == 2||recharge_withdrawals.state == 5}">交易成功</c:if>
									</td>
									<td class="td-col-money tac">
										<a href="javascript:;">详情</a>
									</td>
								</tr>
								</c:forEach>
								</c:if>
								
								<c:if test="${requestScope.listPageType == 1}">
									<c:forEach items="${requestScope.transfers }" var="transfer" varStatus="vs">
										<tr>
											<td class=" tac">${vs.index+1 }</td>
											<c:set scope="page" var="time" value="${transfer.time }"></c:set>
											 <%
							   					Date date2 = (Date)pageContext.getAttribute("time");
												String timeStr2 = MyUtils.dateAndTimeDateToStringNoSeconds(date2);
							   				 %>
											<td class="td-col-date "><%=timeStr2 %></td>
											<td class="td-col-type tac">${transfer.transferName }</td>
											<td class="td-col-sponsor tac">
												<c:if test="${!empty transfer.fromUser}">个人</c:if>
												<c:if test="${!empty transfer.fromEnterprise}">企业</c:if>
											</td>
											<td class=" tac">${transfer.id}</td>
											<td class=" tac">${transfer.money}</td>
											<td class="td-col-status tac">
												<c:if test="${transfer.state == 0||transfer.state == 3}">等待审核</c:if>
												<c:if test="${transfer.state == 1||transfer.state == 4}">审核通过</c:if>
												<c:if test="${transfer.state == 2||transfer.state == 5}">交易成功</c:if>
											</td>
											<td class="td-col-money tac">
												<a href="javascript:;">详情</a>
											</td>
										</tr>
									</c:forEach>
								</c:if>
							</tbody>
						</table>
						<div class="list-page-box">
								 <div id="kkpager"></div>
						</div>
					</div>
				</div>
			</div>
			<div id="bottom" class="bottom"></div>
		</div>
	</body>
	
</html>

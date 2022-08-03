let isShowed = false
notifID = 0

$(function () {
	window.addEventListener('message', function (event) {
		switch (event.data.action) {
			case 'setJob':
				$('.job-text').text(event.data.data + 'ㅤ')
				break
			case 'setMoney':
				$('#cash').text(event.data.cash.toLocaleString() + 'ㅤ')
				$('#bank').text(event.data.bank.toLocaleString() + 'ㅤ')
				if (typeof event.data.black_money !== 'undefined') {
					$('#black_money_item').show()
					$('#black_money').text(event.data.black_money.toLocaleString() + 'ㅤ')
				} else {
					$('#black_money_item').fadeOut()
				}
				break
			case 'initGUI':
				if (event.data.data.whiteMode)
					$('#main').removeClass('mHud')
				if (event.data.data.colorInvert)
					$('img').css('filter', 'unset')
				break
			case 'disableHud':
				event.data.data ? $('#main').fadeOut(300) : $('#main').fadeIn(1000)
				break
		}

	})
})
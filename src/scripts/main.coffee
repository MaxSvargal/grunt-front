(->
	tpl = require '../templates/demo'
	html = tpl {demo: 'This is loaded jade template.'}
	el = document.createElement 'div'
	el.className = 'demo'
	el.innerHTML = html
	document.body.appendChild el
)()
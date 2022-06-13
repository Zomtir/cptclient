//    term = DateFormat("yyyy-MM-dd").parse(json['term'], true).toLocal(),


//  String email;

//email = "default@e-mail.org",
/*
email = json['email'],
'email': email,*/

/*

  Future<void> _saveEmail() async {
    if (_ctrlUserEmail.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid E-Mail')));
      return;
    }

    final response = await http.post(
      Uri.http(navi.server, 'user_email'),
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Token': widget.session.token,
      },
      body: _ctrlUserEmail.text,
    );

    if (response.statusCode != 200) return;

    widget.session.user!.email = _ctrlUserEmail.text;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully changed email')));
  }

      _ctrlUserEmail.text = widget.session.user!.email;

      AppInfoRow(
            info: Text("E-Mail"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserEmail,
              decoration: InputDecoration(
                hintText: "Enter your E-Mail",
                suffixIcon: IconButton(
                  onPressed: _saveEmail,
                  icon: Icon(Icons.save),
                ),
              ),
            ),
          ),
 */
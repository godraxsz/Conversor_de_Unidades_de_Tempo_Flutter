import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Unidades de Tempo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (_loggedIn) {
      return const HomePage();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Página de Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nome de Usuário',
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
              ),
              ElevatedButton(
                onPressed: () {

                  String username = _usernameController.text;
                  String password = _passwordController.text;
                
                  if (username == 'admin' && password == 'password') {
                    setState(() {
                      _loggedIn = true;
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Credenciais inválidas.'),
                        content: const Text(
                            'Por favor, insira um nome de usuário e senha válidos.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Logar ✅'),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bem-vindo, @Admin.',
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UnitConverterPage(),
                  ),
                );
              },
              child: const Text('Ir para o conversor ✨'),
            ),
          ],
        ),
      ),
    );
  }
}

enum TimeUnit {
  milliseconds,
  seconds,
  minutes,
  hours,
  days,
}

class UnitConverterPage extends StatefulWidget {
  const UnitConverterPage({Key? key}) : super(key: key);

  @override
  _UnitConverterPageState createState() => _UnitConverterPageState();
}

class _UnitConverterPageState extends State<UnitConverterPage> {
  final TextEditingController _valueController = TextEditingController();
  TimeUnit _selectedInputUnit = TimeUnit.hours;
  TimeUnit _selectedResultUnit = TimeUnit.seconds;
  String _conversionResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Unidades de Tempo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Insira um valor:',
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Unidade do Input:'),
                DropdownButton<TimeUnit>(
                  value: _selectedInputUnit,
                  onChanged: (TimeUnit? newValue) {
                    setState(() {
                      _selectedInputUnit = newValue!;
                    });
                  },
                  items: TimeUnit.values.map((TimeUnit unit) {
                    return DropdownMenuItem<TimeUnit>(
                      value: unit,
                      child: Text(unitToString(unit)),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Unidade do Resultado:'),
                DropdownButton<TimeUnit>(
                  value: _selectedResultUnit,
                  onChanged: (TimeUnit? newValue) {
                    setState(() {
                      _selectedResultUnit = newValue!;
                    });
                  },
                  items: TimeUnit.values.map((TimeUnit unit) {
                    return DropdownMenuItem<TimeUnit>(
                      value: unit,
                      child: Text(unitToString(unit)),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {

                double value = double.tryParse(_valueController.text) ?? 0;
                double result = convert(value, _selectedInputUnit, _selectedResultUnit);
                setState(() {
                  _conversionResult = result.toStringAsFixed(2);
                });
              },
              child: const Text('Converter 🌟'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Resultado: $_conversionResult',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String unitToString(TimeUnit unit) {
    switch (unit) {
      case TimeUnit.milliseconds:
        return 'Milissegundo';
      case TimeUnit.seconds:
        return 'Segundo';
      case TimeUnit.minutes:
        return 'Minuto';
      case TimeUnit.hours:
        return 'Hora';
      case TimeUnit.days:
        return 'Dia';
    }
  }

  double convert(double value, TimeUnit inputUnit, TimeUnit resultUnit) {
    double result;

    switch (inputUnit) {
      case TimeUnit.milliseconds:
        result = value;
        break;
      case TimeUnit.seconds:
        result = value * 1000;
        break;
      case TimeUnit.minutes:
        result = value * 1000 * 60;
        break;
      case TimeUnit.hours:
        result = value * 1000 * 60 * 60;
        break;
      case TimeUnit.days:
        result = value * 1000 * 60 * 60 * 24;
        break;
    }

    switch (resultUnit) {
      case TimeUnit.milliseconds:
        return result;
      case TimeUnit.seconds:
        return result / 1000;
      case TimeUnit.minutes:
        return result / (1000 * 60);
      case TimeUnit.hours:
        return result / (1000 * 60 * 60);
      case TimeUnit.days:
        return result / (1000 * 60 * 60 * 24);
    }
  }
}

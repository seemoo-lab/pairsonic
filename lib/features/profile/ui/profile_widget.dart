import 'package:flutter/material.dart';
import 'package:pairsonic/constants.dart';
import 'package:pairsonic/features/pairing/pairing_arguments.dart';
import 'package:pairsonic/features/pairing/pairing_screen.dart';
import 'package:pairsonic/features/profile/identity_service.dart';
import 'package:pairsonic/features/profile/user_model.dart';
import 'package:pairsonic/features/setup/ui/icon_selection_widget.dart';
import 'package:pairsonic/generated/l10n.dart';
import 'package:pairsonic/helper/gui_utility_interface.dart';
import 'package:pairsonic/service_locator.dart';

/// Widget to show a [User] profile
///
/// {@category Widgets}
class ProfileWidget extends StatefulWidget {
  const ProfileWidget(
      this.user, {
        this.edit = false,
        this.editMode = false,
        this.showVerification = false,
        this.pairingArguments,
        this.onSave,
        this.onInput,
        super.key,
      });
  final User user;
  final bool edit;
  final bool editMode;
  final bool showVerification;
  final PairingArguments? pairingArguments;
  final Function()? onSave;
  final Function(String, String)? onInput;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final _localDatabaseService = getIt<GuiUtilityInterface>();
  final _identityService = getIt<IdentityService>();

  late bool _isEditable;
  bool _editMode = false;
  bool _showVerification = false;
  PairingArguments? _pairingArguments;
  Function()? _onSave;
  Function(String, String)? _onInput;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _isEditable = widget.edit;
    _editMode = widget.editMode;
    _showVerification = widget.showVerification;
    _pairingArguments = widget.pairingArguments;
    _onSave = widget.onSave;
    _onInput = widget.onInput;
  }

  @override
  Widget build(BuildContext context) {
    if (_editMode) {
      nameController.text = widget.user.name;
      bioController.text = widget.user.bio;
    }

    Widget iconStack = Container(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_showVerification)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.user.verified ? Colors.green : Colors.red,
                  width: 6.0,
                ),
              ),
              child: CircleAvatar(
                radius: 80.0,
                backgroundImage: ExactAssetImage(widget.user.iconPath),
              ),
            )
          else
            CircleAvatar(
              radius: 80.0,
              backgroundImage: ExactAssetImage(widget.user.iconPath),
            ),
          if (_editMode)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IconSelectionScreen(
                      onSelected: (index) {
                        setNewIcon(index);
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.add_photo_alternate,
                size: 40.0,
                color: Color.fromARGB(125, 0, 0, 0),
              ),
            ),
        ],
      ),
    );

    Widget userinfo = _editMode
        ? Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: S.of(context).name,
            ),
            onChanged: (value) {
              _onInput?.call(nameController.text, bioController.text);
              widget.user.name = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).enterName;
              }
              return null;
            },
          ),
          TextFormField(
            controller: bioController,
            decoration: InputDecoration(
              labelText: S.of(context).bio,
            ),
            onChanged: (value) {
              _onInput?.call(nameController.text, bioController.text);
              widget.user.bio = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).enterBio;
              }
              return null;
            },
          )
        ],
      ),
    )
        : Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          widget.user.name,
          textScaler: const TextScaler.linear(2.0),
        ),
        Text(
          widget.user.bio,
          textScaler: const TextScaler.linear(1.0),
          textAlign: TextAlign.center,
        )
      ],
    );



    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Column(
        children: [
          iconStack,
          userinfo,
        ] + maybeEditButton() + maybeReturnButton(),
      ),
    );
  }

  void setNewIcon(int index) {
    setState(() {
      widget.user.iconId = index;
    });
  }

  List<Widget> maybeEditButton() {
    if (_isEditable) {
      return [
        const SizedBox(height: 10),
        ElevatedButton.icon(
          icon: Icon(_editMode ? Icons.done : Icons.edit),
          label: Text(_editMode ? S.of(context).generalButtonDone : S.of(context).profileEditButtonEdit),
          onPressed: () async {
            if (_editMode) {
              if (_formKey.currentState!.validate()) {
                await _localDatabaseService.insertOrUpdateUser(widget.user, allowSelf: true);
                _identityService.setOrUpdateProfile(widget.user);
                _onSave?.call();
                setState(() {
                  _editMode = false;
                });
              }
            } else {
              setState(() {
                _editMode = true;
              });
            }
          },
        )
      ];
    } else {
      return [];
    }
  }

  List<Widget> maybeReturnButton() {
    if (_pairingArguments != null) {
      return [
        const Spacer(flex: 3),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: FloatingActionButton.extended(
                heroTag: "back",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PairingScreen(
                        pairingArgs: _pairingArguments,
                      ),
                    ),
                  );
                },
                backgroundColor: Colors.lightBlueAccent,
                icon: const Icon(Icons.arrow_back),
                label: Text("Back to ${_pairingArguments!.method.readableName(context)}-pairing"),
              ),
            ),
          ),
        ),
        const Spacer(),
      ];
    }
    return [];
  }
}

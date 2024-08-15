import 'package:flutter/material.dart';
import 'package:pairsonic/features/profile/identity_service.dart';
import 'package:pairsonic/features/profile/user_model.dart';
import 'package:pairsonic/generated/l10n.dart';
import 'package:pairsonic/helper/gui_utility_interface.dart';
import 'package:pairsonic/service_locator.dart';

class ContactListWidget extends StatefulWidget {
  const ContactListWidget(this.selectUser, {super.key});
  final Function(User user) selectUser;

  @override
  State<ContactListWidget> createState() => _ContactListWidgetState();
}

class _ContactListWidgetState extends State<ContactListWidget> {
  final _localDatabaseService = getIt<GuiUtilityInterface>();
  final _identityService = getIt<IdentityService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
        future: _localDatabaseService.getAllUser(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            var myUser = _identityService.self;
            snapshot.data!.removeWhere(
                  (element) => element.id == _identityService.self.id,
            );
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                  child: generateUserTile(myUser, self: true),
                ),
                const Divider(color: Colors.black, thickness: 2.0),
                if (snapshot.data!.isEmpty)
                //Only own profile
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ListTile(
                              title: Text(S.of(context).noContacts))),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        User user = snapshot.data![index];
                        debugPrint(user.id);
                        return Card(child: generateUserTile(user));
                      }),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget generateUserTile(User user, {self = false}) {
    return ListTile(
      onTap: () => widget.selectUser(user),
      visualDensity: VisualDensity(vertical: self ? 1 : 0), // to expand
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: self ? 60 : 50,
            width: self ? 60 : 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: self
                    ? Colors.black
                    : user.verified
                    ? Colors.green
                    : Colors.red,
                width: 3.0,
              ),
            ),
            child: CircleAvatar(
              radius: self ? 45 : 40,
              backgroundImage: ExactAssetImage(user.iconPath),
            ),
          ),
        ],
      ),
      title: Text(
        user.name,
        textScaler: TextScaler.linear(self ? 1.3 : 1.1),
      ),
      subtitle: Text(user.bio, maxLines: 2),
    );
  }
}

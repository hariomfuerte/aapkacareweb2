import 'package:flutter/material.dart';
import 'package:aapkacare/values/screen.dart';
import 'package:aapkacare/values/values.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class Extra extends StatefulWidget {
  @override
  State<Extra> createState() => _ExtraState();
}

class _ExtraState extends State<Extra> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  final double maxSlide = 250.0;
  late ValueNotifier<Map<String, List<String>>> filtersNotifier;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    filtersNotifier = ValueNotifier({
      "Profession": [],
      "Experience": [],
    });
  }

  void toggle() => animationController.isDismissed ? animationController.forward() : animationController.reverse();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: toggle,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            double slide = maxSlide * animationController.value;
            return Stack(
              children: <Widget>[
                GestureDetector(onTap: toggle, child: Extra2(filtersNotifier: filtersNotifier)),
                Transform(
                  transform: Matrix4.identity()..translate(slide),
                  alignment: Alignment.bottomCenter,
                  child: Extra1(filtersNotifier: filtersNotifier),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class Extra1 extends StatefulWidget {
  final ValueNotifier<Map<String, List<String>>> filtersNotifier;

  Extra1({required this.filtersNotifier});

  @override
  State<Extra1> createState() => _Extra1State();
}

class _Extra1State extends State<Extra1> {
  late Map<String, List<String>> filters;

  @override
  void initState() {
    super.initState();
    filters = widget.filtersNotifier.value;
    widget.filtersNotifier.addListener(_updateFilters);
  }

  @override
  void dispose() {
    widget.filtersNotifier.removeListener(_updateFilters);
    super.dispose();
  }

  void _updateFilters() {
    setState(() {
      filters = widget.filtersNotifier.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 500,
        height: 1000,
        color: Colors.amber,
        child: Column(
          children: [
            Text("Selected Filters:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(filters.toString(), style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class Extra2 extends StatefulWidget {
  final ValueNotifier<Map<String, List<String>>> filtersNotifier;

  Extra2({required this.filtersNotifier});

  @override
  State<Extra2> createState() => _Extra2State();
}

class _Extra2State extends State<Extra2> {
  final GlobalKey<_DropdownWidgetState> ProfessionKey = GlobalKey<_DropdownWidgetState>();
  final GlobalKey<_DropdownWidgetState> ExperienceKey = GlobalKey<_DropdownWidgetState>();

  @override
  void initState() {
    super.initState();
    printSelectedFilters();
  }

  void clearAllFilters() {
    ProfessionKey.currentState?.clearAll();
    ExperienceKey.currentState?.clearAll();
    widget.filtersNotifier.value = {
      "Profession": [],
      "Experience": [],
    };
  }

  void updateSelectedFilters(String filterName, List<String> selectedItems) {
    widget.filtersNotifier.value = {
      ...widget.filtersNotifier.value,
      filterName: selectedItems,
    };
    printSelectedFilters();
  }

  void printSelectedFilters() {
    print("Selected Filters: ${widget.filtersNotifier.value}");
  }

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Scaffold(
      backgroundColor: Color(0xfff4f9fe),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: s.height,
          child: Container(
            width: 250,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filters",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: s.width < 1024
                            ? s.width > 600
                                ? 19
                                : 16
                            : 22,
                      ),
                    ),
                    GestureDetector(
                      onTap: clearAllFilters,
                      child: Text(
                        "Clear All",
                        style: GoogleFonts.aBeeZee(
                          color: grey,
                          fontWeight: FontWeight.bold,
                          fontSize: s.width < 1024
                              ? s.width > 600
                                  ? 10
                                  : 8
                              : 12,
                        ),
                      ).pOnly(top: 5),
                    ),
                  ],
                ),
                15.heightBox,
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          DropdownWidget(
                            key: ProfessionKey,
                            name: "Profession",
                            items: [
                              "Cardiologist",
                              "Dermatologist",
                              "Pediatricians",
                              "Gynecologist",
                              "Gastroenterologist",
                              "Pathology",
                            ],
                            onSelectionChanged: (selectedItems) {
                              updateSelectedFilters("Profession", selectedItems);
                            },
                          ),
                          Divider(color: Colors.black).px16(),
                          DropdownWidget(
                            key: ExperienceKey,
                            name: "Experience",
                            items: [
                              "1 - 5",
                              "6 - 10",
                              "11 - 15",
                              "16 - 20",
                              "21 - 25",
                            ],
                            onSelectionChanged: (selectedItems) {
                              updateSelectedFilters("Experience", selectedItems);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                15.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownWidget extends StatefulWidget {
  final String name;
  final List<String> items;
  final ValueChanged<List<String>> onSelectionChanged;

  DropdownWidget({required this.items, required this.name, required this.onSelectionChanged, Key? key}) : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  bool _showDropdown = true;
  List<bool> isCheckedList = [];

  @override
  void initState() {
    super.initState();
    isCheckedList = List<bool>.filled(widget.items.length, false);
  }

  void clearAll() {
    setState(() {
      isCheckedList = List<bool>.filled(widget.items.length, false);
      widget.onSelectionChanged(_getSelectedItems());
    });
  }

  List<String> _getSelectedItems() {
    List<String> selectedItems = [];
    for (int i = 0; i < widget.items.length; i++) {
      if (isCheckedList[i]) {
        selectedItems.add(widget.items[i]);
      }
    }
    return selectedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _showDropdown = !_showDropdown;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name,
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 16),
              ).pOnly(left: 5),
              Icon(
                _showDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                size: 30,
              ).pOnly(top: 5),
            ],
          ).p(12),
        ),
        Visibility(
          visible: _showDropdown,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: widget.items.asMap().entries.map((entry) {
                int index = entry.key;
                String item = entry.value;
                return InkWell(
                  onTap: () {
                    setState(() {
                      isCheckedList[index] = !isCheckedList[index];
                      widget.onSelectionChanged(_getSelectedItems());
                    });
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Transform.scale(
                      scale: 0.8,
                      child: Checkbox(
                        activeColor: Colors.yellow,
                        value: isCheckedList[index],
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedList[index] = value ?? false;
                            widget.onSelectionChanged(_getSelectedItems());
                          });
                        },
                      ),
                    ),
                    title: Text(item, style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

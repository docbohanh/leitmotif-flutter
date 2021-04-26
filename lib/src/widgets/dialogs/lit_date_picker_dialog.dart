import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:lit_ui_kit/src/widgets/date_picker/lit_date_picker.dart';

class LitDatePickerDialog extends StatefulWidget {
  final void Function() onBackCallback;
  //final DateTime? selectedDate;
  //final void Function(DateTime?) selectDate;
  final void Function(DateTime) onSubmit;
  final bool allowFutureDates;
  final String excludedMonthErrorMessage;
  final String futureDateErrorMessage;
  const LitDatePickerDialog(
      {Key? key,
      required this.onBackCallback,
      //required this.selectedDate,
      //required this.selectDate,
      required this.onSubmit,
      this.allowFutureDates = true,
      this.excludedMonthErrorMessage = "Date not included in current month.",
      this.futureDateErrorMessage = "Future dates are not allowed."})
      : super(key: key);
  @override
  _LitDatePickerDialogState createState() => _LitDatePickerDialogState();
}

class _LitDatePickerDialogState extends State<LitDatePickerDialog>
    with TickerProviderStateMixin {
  late AnimationController _selectAnimationController;
  CalendarController _calendarController = CalendarController();
  late LitSnackbarController _exclusiveDateSnackBarController;
  late LitSnackbarController _futureDateSnackbarController;
  DateTime? selectedDate;
  String? weekdayLabels;

  void _setSelectedDate(DateTime date) {
    print(date);
    setState(() {
      if (selectedDate == date) {
        selectedDate = null;
        _selectAnimationController.reverse();
      } else {
        selectedDate = date;
        _selectAnimationController.forward(from: 0);
      }
    });
  }

  void _onExclusiveMonth() {
    _exclusiveDateSnackBarController.showSnackBar();
  }

  void _onFutureDate() {
    _futureDateSnackbarController.showSnackBar();
  }

  void _onSubmitDate() {
    widget.onSubmit(selectedDate!);
  }

  @override
  void initState() {
    super.initState();

    _selectAnimationController =
        AnimationController(duration: Duration(milliseconds: 140), vsync: this);

    _exclusiveDateSnackBarController = LitSnackbarController()..init(this);
    _futureDateSnackbarController = LitSnackbarController()..init(this);
  }

  @override
  void dispose() {
    _exclusiveDateSnackBarController.dispose();
    _futureDateSnackbarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _selectAnimationController,
      builder: (context, _) {
        return Material(
          color: selectedDate != null
              ? Colors.black
                  .withOpacity((0.38 * _selectAnimationController.value))
              : Colors.transparent,
          child: Stack(
            alignment: alternativeAlignment(MediaQuery.of(context).size,
                portraitAlignment: Alignment.center,
                landscapeAlignment: Alignment.topCenter),
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: LitTitledDialog(
                  titleText: "Previous day",
                  leading: DialogBackButton(
                    onPressed: widget.onBackCallback,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: LitDatePicker(
                    calendarController: _calendarController,
                    selectedDate: selectedDate,
                    setSelectedDate: _setSelectedDate,
                    onExclusiveMonth: _onExclusiveMonth,
                    onFutureDate: _onFutureDate,
                    allowFutureDates: widget.allowFutureDates,
                  ),
                ),
              ),
              Align(
                alignment: alternativeAlignment(MediaQuery.of(context).size,
                    portraitAlignment: Alignment.bottomCenter,
                    landscapeAlignment: Alignment.topRight),
                child: Container(
                  child: selectedDate != null
                      ? AnimatedOpacity(
                          duration: _selectAnimationController.duration!,
                          opacity:
                              0.5 + (_selectAnimationController.value * 0.5),
                          child: Transform(
                            transform: Matrix4.translationValues(
                                0,
                                -32 + (_selectAnimationController.value * 32),
                                0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 24.0,
                                horizontal: 16.0,
                              ),
                              child: LitGradientButton(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8.0,
                                    color: Colors.black45,
                                    offset: Offset(-2, 2),
                                    spreadRadius: 2.0,
                                  ),
                                ],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                child: Text(
                                  "${DateFormat.yMMMMd((Localizations.localeOf(context).languageCode)).format(selectedDate!)}",
                                  style: LitTextStyles.sansSerif.copyWith(
                                      fontSize: alternativeFontSize(
                                        MediaQuery.of(context).size,
                                        potraitFontSize: 19.0,
                                        landscapeFontSize: 16.0,
                                      ),
                                      fontWeight: FontWeight.w700),
                                ),
                                onPressed: _onSubmitDate,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ),
              ),
              IconSnackbar(
                iconData: LitIcons.info,
                text: widget.excludedMonthErrorMessage,
                textStyle: LitTextStyles.sansSerif
                    .copyWith(color: Colors.white, fontSize: 13.0),
                litSnackBarController: _exclusiveDateSnackBarController,
                alignment: Alignment.topRight,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              ),
              IconSnackbar(
                iconData: LitIcons.info,
                text: widget.futureDateErrorMessage,
                textStyle: LitTextStyles.sansSerif
                    .copyWith(color: Colors.white, fontSize: 13.0),
                litSnackBarController: _futureDateSnackbarController,
                alignment: Alignment.topRight,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              ),
            ],
          ),
        );
      },
    );
  }
}

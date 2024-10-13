part of 'home_page_bloc.dart';

@immutable
sealed class HomePageState {}

final class HomePageInitial extends HomePageState {}

final class HomePageLoading extends HomePageState {}

final class TasksLoaded extends HomePageState{}

final class ErrorLoadingTasks extends HomePageState{}

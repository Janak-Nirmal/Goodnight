//
//  GNTimesViewController.m
//  Goodnight
//
//  Created by Matt Zanchelli on 9/19/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "GNTimesViewController.h"

#import "GNAlarmViewController.h"

@interface GNTimesViewController () <GNAlarmViewControllerDelegate>

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;

@property (strong, nonatomic) IBOutlet UILabel *instructionalLabel;

@property (strong, nonatomic) IBOutlet UIButton *time1;
@property (strong, nonatomic) IBOutlet UIButton *time2;
@property (strong, nonatomic) IBOutlet UIButton *time3;
@property (strong, nonatomic) IBOutlet UIButton *time4;

@property (strong, nonatomic) UIButton *selectedTime;
@property (nonatomic) CGRect timeFrame;

@property (strong, nonatomic) IBOutlet UIView *backButton;

@property (strong, nonatomic) GNAlarmViewController *alarmViewController;

@end

#define SLEEP_IMAGE @"Sleep_Glyph_Small"
#define WAKE_IMAGE @"Wake_Glyph_Small"

#define BAD_OPACITY   0.4f
#define FINE_OPACITY  0.6f
#define GOOD_OPACITY  0.8f
#define GREAT_OPACITY 1.0f

#define FALL_ASLEEP_TIME (14*60)
#define SLEEP_CYCLE_TIME (90*60)
#define BAD_SLEEP_TIME   (FALL_ASLEEP_TIME+(3*SLEEP_CYCLE_TIME))
#define FINE_SLEEP_TIME  (FALL_ASLEEP_TIME+(4*SLEEP_CYCLE_TIME))
#define GOOD_SLEEP_TIME  (FALL_ASLEEP_TIME+(5*SLEEP_CYCLE_TIME))
#define GREAT_SLEEP_TIME (FALL_ASLEEP_TIME+(6*SLEEP_CYCLE_TIME))

#define ANIMATION_DURATION 0.75f

@implementation GNTimesViewController

#pragma mark Initializations

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark Getting set up

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// Setup formatter
	_dateFormatter = [[NSDateFormatter alloc] init];
	_dateFormatter.dateFormat = @"h:mm a";
	
	// Setup mode specific things
	if ( _mode == GNTimesViewControllerModeSleepTimes ) {
		[self setupForSleepMode];
	} else if ( _mode == GNTimesViewControllerModeWakeTimes ) {
		[self setupForWakeMode];
	}
	
	_alarmViewController = [[GNAlarmViewController alloc] initWithNibName:@"GNAlarmViewController" bundle:nil];
	_alarmViewController.view.frame = self.view.frame;
	_alarmViewController.view.alpha = 0.0f;
	[self.view addSubview:_alarmViewController.view];
	_alarmViewController.delegate = self;
}

- (void)setupForSleepMode
{
	_headerLabel.text = @"Sleep";
	
	_headerImage.image = [UIImage imageNamed:SLEEP_IMAGE];
	
	_instructionalLabel.text = @"Try falling asleep at\none of these times:";
}

- (void)setTimesForSleepMode
{
	// Times
	NSDate *date;
	date = [_date dateByAddingTimeInterval:-GREAT_SLEEP_TIME];
	[_time1 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time1.alpha = GREAT_OPACITY;
	
	date = [_date dateByAddingTimeInterval:-GOOD_SLEEP_TIME];
	[_time2 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time2.alpha = GOOD_OPACITY;
	
	date = [_date dateByAddingTimeInterval:-FINE_SLEEP_TIME];
	[_time3 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time3.alpha = FINE_OPACITY;
	
	date = [_date dateByAddingTimeInterval:-BAD_SLEEP_TIME];
	[_time4 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time4.alpha = BAD_OPACITY;
}

- (void)setupForWakeMode
{
	_headerLabel.text = @"Wake";
	
	_headerImage.image = [UIImage imageNamed:WAKE_IMAGE];
	
	_instructionalLabel.text = @"Try waking up at\none of these times:";
}

- (void)setTimesForWakeMode
{
	// Times
	NSDate *date;
	date = [_date dateByAddingTimeInterval:BAD_SLEEP_TIME];
	[_time1 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time1.alpha = BAD_OPACITY;
	
	date = [_date dateByAddingTimeInterval:FINE_SLEEP_TIME];
	[_time2 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time2.alpha = FINE_OPACITY;
	
	date = [_date dateByAddingTimeInterval:GOOD_SLEEP_TIME];
	[_time3 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time3.alpha = GOOD_OPACITY;
	
	date = [_date dateByAddingTimeInterval:GREAT_SLEEP_TIME];
	[_time4 setTitle:[_dateFormatter stringFromDate:date]
			forState:UIControlStateNormal];
	_time4.alpha = GREAT_OPACITY;
}


#pragma mark Button Actions

- (IBAction)didTapBackButton:(id)sender
{
	if ( _delegate && [_delegate respondsToSelector:@selector(timesViewControllerRequestsDismissal)] ) {
		[_delegate timesViewControllerRequestsDismissal];
	}
}

- (IBAction)didTapTime:(UIButton *)sender
{
	// Set date - switch depending on button
	NSDate *date;
	switch ( self.mode ) {
		case GNTimesViewControllerModeWakeTimes: {
		} break;
		case GNTimesViewControllerModeSleepTimes: {
		} break;
	}
	
	[_delegate timesViewControllerDidSetAlarm];
	
	// Keep track of the time's frame
	_selectedTime = sender;
	_timeFrame = sender.frame;
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _headerImage.alpha = 0.0f;
						 _headerLabel.alpha = 0.0f;
						 _instructionalLabel.alpha = 0.0f;
						 
						 if ( sender != _time1 ) _time1.alpha = 0.0f;
						 if ( sender != _time2 ) _time2.alpha = 0.0f;
						 if ( sender != _time3 ) _time3.alpha = 0.0f;
						 if ( sender != _time4 ) _time4.alpha = 0.0f;
						 
						 _backButton.alpha = 0.0f;
						 
						 sender.alpha = 0.7f;
					 }
					 completion:^(BOOL finished) {}];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 sender.frame = _alarmViewController.alarmTimeLabelFrame;
					 }
					 completion:^(BOOL finished) {}];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:ANIMATION_DURATION/3
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _alarmViewController.view.alpha = 1.0f;
						 
					 }
					 completion:^(BOOL finished) {}];
}


#pragma mark Alarm View Controller Delegate

- (void)alarmViewControllerDidCancelAlarm
{
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _alarmViewController.view.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
//						 _selectedTime = nil;
//						 _timeFrame = CGRectZero;
					 }];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _selectedTime.frame = _timeFrame;
					 }
					 completion:^(BOOL finished) {}];
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:ANIMATION_DURATION/3
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 _headerImage.alpha = 1.0f;
						 _headerLabel.alpha = 1.0f;
						 _instructionalLabel.alpha = 1.0f;
						 
						 // Indirectly resets alphas for times
						 [self setDate:_date];
						 
						 _backButton.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
	
	[_delegate timesViewControllerDidCancelAlarm];
}


#pragma mark Properties
- (void)setMode:(GNTimesViewControllerMode)mode
{
	_mode = mode;
	if ( mode == GNTimesViewControllerModeSleepTimes ) {
		[self setupForSleepMode];
	} else if ( mode == GNTimesViewControllerModeWakeTimes ) {
		[self setupForWakeMode];
	}
}

- (void)setDate:(NSDate *)date
{
	_date = date;
	switch (_mode) {
		case GNTimesViewControllerModeSleepTimes:
			[self setTimesForSleepMode];
			break;
		case GNTimesViewControllerModeWakeTimes:
		default:
			[self setTimesForWakeMode];
			break;
	}
}


#pragma mark Animations

- (void)animateIn
{
	// Move text back below view

	// animate
	// Move text into view
}

- (void)animateOut
{
	// Move text out of view
	
	// animate
	// Move text back below view
}


#pragma mark Take Down

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

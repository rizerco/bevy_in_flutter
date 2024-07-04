#[cfg(target_os = "android")]
mod android;
#[cfg(target_os = "android")]
pub use android::*;

#[cfg(target_vendor = "apple")]
mod ios;
#[cfg(target_vendor = "apple")]
pub use ios::*;

String getFullSectionLabel(String shortName) {
  switch (shortName) {
    case 'அறம்':
      return 'அறத்துப்பால் (Virtue)';
    case 'பொருள்':
      return 'பொருட்பால் (Wealth)';
    case 'இன்பம்':
      return 'காமத்துப்பால் (Love)';
    default:
      return shortName;
  }
}

import React from "react";
import Icon from "./Icon";
import { Props } from "./Icon";

export default function RestoreIcon(
  props: Props
): React.ReactElement<React.ComponentProps<any>, any> {
  return (
    <Icon {...props}>
      <path
        fillRule="evenodd"
        clipRule="evenodd"
        d="M17.3713 16.5957C16.905 16.2996 16.7671 15.6817 17.0632 15.2154C17.1217 15.1234 17.1773 15.0304 17.2302 14.9365C17.4879 14.4767 17.6848 13.9843 17.8149 13.4728C17.8186 13.4582 17.8226 13.4437 17.8269 13.4294C18.0987 12.3228 18.0442 11.1719 17.694 10.1127C17.6564 9.99948 17.6151 9.88655 17.5702 9.77409C17.4514 9.47653 17.3117 9.19432 17.1537 8.92828L17.1426 8.90918C16.6778 8.13424 16.0302 7.45291 15.2155 6.93545C15.1047 6.8651 14.9925 6.79883 14.8791 6.73661C14.4358 6.49442 13.9631 6.3084 13.4729 6.18369C13.459 6.18016 13.4453 6.17636 13.4317 6.17228C12.3013 5.8943 11.1247 5.95662 10.0467 6.32692C9.95561 6.35838 9.86473 6.39218 9.77415 6.42836C9.76612 6.43157 9.75807 6.43467 9.75 6.43766C8.91581 6.77422 8.1512 7.30022 7.52707 7.99984H8.99982C9.5521 7.99984 9.99982 8.44756 9.99982 8.99984C9.99982 9.55213 9.5521 9.99984 8.99982 9.99984L5.00047 9.99984C4.44819 9.99984 4.00047 9.55213 4.00047 8.99984L4.00047 5.0005C4.00047 4.44821 4.44819 4.0005 5.00047 4.0005C5.55276 4.0005 6.00047 4.44821 6.00047 5.0005V6.70655C6.94885 5.62897 8.14544 4.85556 9.44759 4.41814C9.70662 4.33073 9.96761 4.25731 10.2297 4.19758C10.2465 4.19373 10.2634 4.19033 10.2803 4.18737C12.1288 3.78058 14.1211 4.02568 15.8829 5.0062C16.0121 5.07785 16.1393 5.15309 16.2645 5.23187C16.2746 5.2382 16.2845 5.24467 16.2942 5.25128C17.9247 6.28896 19.0522 7.81919 19.606 9.52456C19.6823 9.75828 19.7472 9.99351 19.801 10.2296C19.8046 10.2456 19.8079 10.2616 19.8107 10.2776C20.2234 12.1496 19.9673 14.1694 18.9558 15.948C18.8952 16.0549 18.8322 16.1604 18.7667 16.2645C18.761 16.2735 18.7552 16.2824 18.7493 16.2913C18.4523 16.7546 17.8363 16.8911 17.3713 16.5957ZM5.12883 13.6667C5.64171 13.4618 6.22356 13.7115 6.42842 14.2244C6.54727 14.522 6.68695 14.8042 6.84494 15.0702C7.12695 15.5451 6.9706 16.1587 6.49574 16.4407C6.02088 16.7227 5.40732 16.5663 5.12532 16.0915C4.91443 15.7363 4.72866 15.3608 4.5711 14.9663C4.36624 14.4534 4.61594 13.8716 5.12883 13.6667ZM7.42032 17.3877C7.71446 16.9202 8.33184 16.7798 8.79928 17.0739C9.33226 17.4093 9.91547 17.6596 10.5258 17.8148C11.061 17.951 11.3845 18.4953 11.2483 19.0305C11.1122 19.5657 10.5679 19.8892 10.0327 19.7531C9.22004 19.5464 8.44379 19.2132 7.7341 18.7666C7.26666 18.4725 7.12617 17.8551 7.42032 17.3877ZM12.5717 19.0482C12.449 18.5097 12.786 17.9737 13.3245 17.851C13.6261 17.7822 13.9269 17.689 14.2245 17.5702C14.522 17.4513 14.8042 17.3116 15.0703 17.1536C15.5452 16.8716 16.1587 17.028 16.4407 17.5028C16.7227 17.9777 16.5664 18.5913 16.0915 18.8733C15.7364 19.0841 15.3608 19.2699 14.9663 19.4275C14.5719 19.585 14.1717 19.7091 13.769 19.8009C13.2305 19.9237 12.6945 19.5867 12.5717 19.0482Z"
      />
    </Icon>
  );
}
